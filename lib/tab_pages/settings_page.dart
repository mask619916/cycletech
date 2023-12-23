import 'package:cycletech/globals/globaldata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _isPublic = false;

  void savePref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('public', _isPublic);
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = (currBrightness == Brightness.dark) ? true : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Dark mode toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    activeColor: Colors.green[400],
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() => _isDarkMode = value);
                      Brightness temp =
                          value ? Brightness.dark : Brightness.light;
                      brightnessStream.add(temp);
                      savePref();
                    },
                  ),
                ],
              ),

              // Privacy toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Leaderboard Public Privacy'),
                  Switch(
                    activeColor: Colors.green[400],
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() => _isPublic = value);
                      savePref();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
