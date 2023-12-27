import 'dart:async';
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

  void _initPositionStream() {
    int distanceFilterInMeters = 10;
    LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: distanceFilterInMeters,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 1),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
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
        // Only set to true if our app will be started up in the background.
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
          // print('Location not found');
          return;
        }

        setState(() {
          _locationCords = LatLng(position.latitude, position.longitude);
        });

        // print(_locationCords);
        // print(position.heading);

        _mapController.moveAndRotate(
          _locationCords,
          18,
          360 - position.heading,
        );

        _points.add(_locationCords);
      },
    );
  }

  Widget displayControls() {
    return Column(
      children: [
        SizedBox(height: 10),
        Text('00h:00m:00s'),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.play_circle_fill_rounded,
                size: 70,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.play_circle_fill_rounded,
                size: 70,
                color: Colors.green,
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
      appBar: AppBar(title: Text('Enjoy your ride!')),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: Color.fromARGB(255, 16, 16, 16),
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
