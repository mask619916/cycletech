import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/utilities/achievement_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.userDetails});

  final UserDetails userDetails;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Position? initialPos;
  final MapController _mapController = MapController();
  late StreamSubscription<Position> _positionStream;
  LatLng _locationCords = LatLng(0, 0);
  List<LatLng> _points = [];
  bool _isFinished = false;
  String _timeElapsed = '';
  String _speed = '0.0'; // in m/s
  String _distance = '0.0'; // in meters
  String _caloriesBurnt = '0.0';

  // void _checkAndUpdateAchievements() async {
  //   try {
  //     // Convert _points from LatLng to GeoPoint
  //     final List<GeoPoint> geoPoints = _points.map((latLng) {
  //       return GeoPoint(latLng.latitude, latLng.longitude);
  //     }).toList();
  //
  //     // Call the function from the AchievementHelper class
  //     AchievementHelper.checkAndUpdateAchievements(
  //       userEmail: widget.userDetails.email!,
  //     );
  //   } catch (e) {
  //     print('Error checking and updating achievements: $e');
  //   }
  // }

  void _updateInformation(Position position) {
    _speed = position.speed.toStringAsFixed(2);

    // print(_points);

    if (_points.length > 1) {
      final LatLng lastPoint = _points[_points.length - 2];

      // print('Last Point: $lastPoint');
      // print('Current Point: ${LatLng(position.latitude, position.longitude)}');

      final distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        position.latitude,
        position.longitude,
      );

      // print('Distance: $distance meters');

      if (distance > 0.0) {
        double tempDistance = double.parse(_distance);
        tempDistance += distance;
        _distance = tempDistance.toStringAsFixed(0);
      }
    }

    double tempCal = double.parse(_caloriesBurnt);
    tempCal = double.parse(_distance) * 0.0035; // assuming calories per meter
    _caloriesBurnt = tempCal.toStringAsFixed(1);
  }

  // Stopwatch stuff
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  bool _isRunning = false;

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

        setState(() {
          _updateInformation(position);
        });
      },
    );
  }

  // For stopwatch
  void _updateTimer(Timer timer) {
    if (_isRunning) {
      setState(() {
        // Rebuild the UI every tick to update the stopwatch display
      });
    }
  }

  String _formattedTime() {
    int hundreds = (_stopwatch.elapsedMilliseconds ~/ 10) % 100;
    int seconds = (_stopwatch.elapsedMilliseconds ~/ 1000) % 60;
    int minutes = (_stopwatch.elapsedMilliseconds ~/ (1000 * 60)) % 60;
    int hours = (_stopwatch.elapsedMilliseconds ~/ (1000 * 60 * 60)) % 24;

    _timeElapsed =
        '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundreds.toString().padLeft(2, '0')}';

    return _timeElapsed;
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
    });
  }

  // Uncomment if required in future
  // void _resetStopwatch() {
  //   setState(() {
  //     _isRunning = true;
  //     _stopwatch.reset();
  //   });
  // }

  Widget _displayControls() {
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Time Elapsed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          _formattedTime(),
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
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
            ),
            Expanded(
              child: Column(
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
            ),
            Expanded(
              child: Column(
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
            ),
          ],
        ),
        SizedBox(height: 20),
        _isFinished
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_positionStream.isPaused) {
                          _startStopwatch();
                          _positionStream.resume();
                        } else {
                          _stopStopwatch();
                          _positionStream.pause();
                        }
                      });
                    },
                    icon: Icon(
                      _positionStream.isPaused
                          ? Icons.play_circle_filled_rounded
                          : Icons.pause_circle_filled_rounded,
                      size: 70,
                      color: _positionStream.isPaused
                          ? Colors.green
                          : Colors.yellow,
                    ),
                  ),
                  _positionStream.isPaused && double.parse(_distance) > 20
                      ? IconButton(
                          onPressed: () async {
                            setState(() => _isFinished = true);
                            _mapController.fitCamera(CameraFit.coordinates(
                              coordinates: _points,
                              maxZoom: 16,
                            ));

                            // Call the function to check and update achievements
                            currUserDetails = (await AchievementHelper
                                .checkAndUpdateAchievements(
                              userDetails: widget.userDetails,
                            ))!;

                            // Call the new function to check and update the Sun achievement
                            // AchievementHelper
                            //     .checkAndUpdateSunAchievement(
                            //   userDetails: widget.userDetails,
                            // );

                            // Call the new function to check and update the Meteor achievement
                            // AchievementHelper
                            //     .checkAndUpdateMeteorAchievement(
                            //   userDetails: widget.userDetails,
                            // );

                            // Call the new function to check and update the Hand Holding Heart achievement
                            // AchievementHelper
                            //     .checkAndUpdateHandHoldingHeartAchievement(
                            //   userDetails: widget.userDetails,
                            // );

                            // Call the new function to check and update the Award achievement
                            // await AchievementHelper
                            //     .checkAndUpdateAwardAchievement(
                            //   userDetails: widget.userDetails,
                            // );

                            final collectionRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userDetails.email)
                                .collection('trackedRides');

                            final List<GeoPoint> tempPointsList = [];
                            for (int i = 0; i < _points.length; i++) {
                              tempPointsList.add(
                                GeoPoint(
                                  _points[i].latitude,
                                  _points[i].longitude,
                                ),
                              );
                            }

                            collectionRef
                                .add({
                                  'calories': _caloriesBurnt,
                                  'distance': _distance,
                                  'timeElapsed': _timeElapsed,
                                  'coordinates': tempPointsList,
                                  'date': Timestamp.now(),
                                })
                                .then((value) =>
                                    debugPrint('Ride has been uploaded.'))
                                .onError((error, stackTrace) => debugPrint(
                                    'An error occurred while uploading ride statistics.'));
                          },
                          icon: Icon(
                            FontAwesomeIcons.flagCheckered,
                            size: 50,
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                ],
              ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _initPositionStream();
    _timer = Timer.periodic(Duration(milliseconds: 30), _updateTimer);
    _positionStream.pause();
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _stopwatch.stop();
    _timer.cancel();
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
        minHeight: _isFinished ? 180 : 275,
        panel: _displayControls(),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(25.848767, 50.567386),
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
                      color: Colors.blueGrey,
                      strokeWidth: 10,
                    ),
                  ],
                ),
                _isFinished
                    ? Container()
                    : MarkerLayer(
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
                _isFinished
                    ? MarkerLayer(
                        alignment: Alignment.topCenter,
                        markers: [
                          Marker(
                            point: _points.first,
                            rotate: true,
                            child: const Icon(
                              Icons.pin_drop,
                              color: Colors.green,
                              size: 38,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                _isFinished
                    ? MarkerLayer(
                        alignment: Alignment.topCenter,
                        markers: [
                          Marker(
                            point: _points.last,
                            rotate: true,
                            child: const Icon(
                              Icons.pin_drop,
                              color: Colors.red,
                              size: 38,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
