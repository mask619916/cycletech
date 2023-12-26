import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

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
                initialCenter: LatLng(26.0993, 50.5124),
                initialZoom: 16,
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
