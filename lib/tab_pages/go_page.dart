import 'package:cycletech/map_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GoPage extends StatefulWidget {
  const GoPage({super.key});

  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  Future<Widget?> _getButtonWidget() async {
    bool isLocationAccessPermitted = false;
    // await Permission.location
    //     .onDeniedCallback(() => isLocationAccessPermitted = false)
    //     .onGrantedCallback(() => isLocationAccessPermitted = true)
    //     .request();

    await Permission.location.request().then(
      (value) {
        isLocationAccessPermitted = value.isGranted;

        if (isLocationAccessPermitted) {
          return CircleAvatar(
            backgroundColor: Colors.black87,
            radius: 110,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blue[100],
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
        } else {
          return locationPermissionText;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getButtonWidget();
  }

  Widget locationPermissionText =
      const Text('Permission for location usage not granted.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: _getButtonWidget(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.data ?? locationPermissionText;
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
