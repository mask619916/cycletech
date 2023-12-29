import 'dart:async';
import 'package:cycletech/globals/globaldata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  late StreamSubscription<Position> _positionStream;
  LatLng _locationCords = LatLng(0, 0);
  List<LatLng> _points = [];
  late Timer _timer;
  late DateTime _startTime;
  String _formattedTime = '00:00:00';
  double _speed = 0.0; // in m/s
  double _distance = 0.0; // in meters
  double _caloriesBurnt = 0.0;

  void _startTimer() {
    _startTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_startTime);
      setState(() {
        _formattedTime = _formatDuration(elapsed);
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _updateInformation(Position position) {
    _speed = position.speed ?? 0.0;

    if (_points.isNotEmpty) {
      final lastPoint = _points.last;
      final distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        position.latitude,
        position.longitude,
      );
      _distance += distance;
    }

    _caloriesBurnt = _distance * 0.000621371; // assuming calories per meter

    setState(() {});
  }

  void _initPositionStream() {
    int distanceFilterInMeters = 10;
    LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: distanceFilterInMeters,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "CycleTech will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        distanceFilter: distanceFilterInMeters,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: distanceFilterInMeters,
      );
    }

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position == null) {
          return;
        }

        setState(() {
          _locationCords = LatLng(position.latitude, position.longitude);
        });

        _mapController.moveAndRotate(
          _locationCords,
          18,
          360 - position.heading,
        );

        _points.add(_locationCords);

        if (!_timer.isActive) {
          _startTimer();
        }

        _updateInformation(position);
      },
    );
  }

  Widget displayControls() {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Time Elapsed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          _formattedTime,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(
                  Icons.speed,
                  size: 30,
                  color: Colors.blue,
                ),
                Text('Speed'),
                Text('$_speed m/s'),
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 30,
                  color: Colors.orange,
                ),
                Text('Distance'),
                Text('$_distance meters'),
              ],
            ),
            Column(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 30,
                  color: Colors.red,
                ),
                Text('Calories Burnt'),
                Text('$_caloriesBurnt'),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _startTimer();
              },
              icon: Icon(
                Icons.play_circle_fill_rounded,
                size: 70,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                _timer.cancel();
              },
              icon: Icon(
                Icons.stop_circle_rounded,
                size: 70,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _initPositionStream();
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enjoy your ride!'),
        backgroundColor: currBrightness == Brightness.dark
            ? Colors.black54
            : Colors.blue[100],
        foregroundColor:
            currBrightness == Brightness.dark ? Colors.white : Colors.black54,
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: currBrightness == Brightness.dark
            ? Colors.black
            : Colors.blue.shade100,
        parallaxEnabled: true,
        parallaxOffset: 0.6,
        minHeight: 120,
        panel: displayControls(),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(25.948767, 50.567386),
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.cycletech',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _points,
                      color: Colors.red,
                      strokeWidth: 10,
                    ),
                  ],
                ),
                MarkerLayer(
                  alignment: Alignment.topCenter,
                  markers: [
                    Marker(
                      point: _locationCords,
                      rotate: true,
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.blueAccent,
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
