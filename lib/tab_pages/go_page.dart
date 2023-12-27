import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/tab_pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GoPage extends StatefulWidget {
  const GoPage({super.key});

  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  Future<void> _getPermission() async {
    bool isLocationAccessPermitted = false;
    await Permission.location
        .onDeniedCallback(() => isLocationAccessPermitted = false)
        .onGrantedCallback(() => isLocationAccessPermitted = true)
        .request();

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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MapPage(),
                  ),
                );
              },
              icon: Icon(Icons.gas_meter_outlined, size: 150),
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
  }

  Widget _displayedWidget =
      const Text('Permission for location usage not granted.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _displayedWidget,
        ),
      ),
    );
  }
}
