import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/tab_pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Define the GoPage widget
class GoPage extends StatefulWidget {
  const GoPage({super.key, required this.userDetails});

  final UserDetails userDetails;

  @override
  State<GoPage> createState() => _GoPageState();
}

// Define the state for the GoPage widget
class _GoPageState extends State<GoPage> {
  // Function to request location permissions
  Future<void> _getPermission() async {
    bool isLocationAccessPermitted = false;
    
    // Request location permissions
    await Permission.location
        .onDeniedCallback(() => isLocationAccessPermitted = false)
        .onGrantedCallback(() => isLocationAccessPermitted = true)
        .request();

    // If location access is permitted, display the navigation button
    if (isLocationAccessPermitted) {
      setState(() {
        _displayedWidget = CircleAvatar(
          backgroundColor:
              currBrightness == Brightness.dark ? Colors.white : Colors.black87,
          radius: 110,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: currBrightness == Brightness.dark
                ? Colors.black54
                : Colors.blue[100],
            child: IconButton(
              onPressed: () {
                // Navigate to the MapPage
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MapPage(userDetails: widget.userDetails),
                  ),
                );
              },
              icon: Icon(Icons.navigation_sharp, size: 150),
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize by requesting location permissions
    _getPermission();
  }

  // Widget to display based on permission status
  Widget _displayedWidget =
      const Text('Permission for location usage not granted.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _displayedWidget, // Displayed widget based on permission status
        ),
      ),
    );
  }
}
