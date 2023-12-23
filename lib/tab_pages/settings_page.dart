import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Brightness? _brightness;

  bool _isdarkmode = false;
  bool _ispublic = false;

  void savepref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('darkmode', _brightness.toString());
    await prefs.setBool('public', _ispublic);
  }

  void loadpref() async {
    String temp;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    temp = prefs.getString('darkmode') ?? "Brightness.light";

    setState(() {
      switch (temp) {
        case "Brightness.light":
          _brightness = Brightness.light;
          _isdarkmode = false;
          break;
        case "Brightness.dark":
          _brightness = Brightness.dark;
          _isdarkmode = true;
          break;
        default:
          _brightness = Brightness.light;
          _isdarkmode = false;
          break;
      }

      _ispublic = prefs.getBool('public') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadpref();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  Switch(
                    activeColor: Colors.green[400],
                    value: _isdarkmode,
                    onChanged: (value) {
                      setState(() {
                        _isdarkmode = value;
                      });
                      savepref();
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Leaderboard Public Privacy'),
                  Switch(
                    activeColor: Colors.green[400],
                    value: _ispublic,
                    onChanged: (value) {
                      setState(() {
                        _ispublic = value;
                      });
                      savepref();
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
