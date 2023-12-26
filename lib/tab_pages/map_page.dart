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
  late Position _currentPosition;
  LatLng _currentLocation = LatLng(0.0, 0.0);

  Future<void> _getCurrentLocation() async {
    // bool serviceEnabled;
    // LocationPermission permission;

    // Check if location services are enabled
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled, ask user to enable them
    //   return;
    // }

    // Request permission to access location
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, show error or ask user to enable them manually
    //     return;
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   return;
    // }

    // Get the current position
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    print("${_currentPosition.latitude}, ${_currentPosition.longitude}");

    setState(() {
      // Update UI with the current position
      _currentLocation =
          LatLng(_currentPosition.latitude, _currentPosition.longitude);
    });

    print(_currentLocation);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enjoy your ride!'),
      ),
      body: SlidingUpPanel(
        panel: Container(),
        body: Stack(
          children: [
            FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 10,
                
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
