import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isdarkmode = false;
  bool _ispublic = false;

  void savepref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkmode', _isdarkmode);
    await prefs.setBool('public', _ispublic);
  }

  void loadpref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isdarkmode = prefs.getBool('darkmode') ?? false;
      _ispublic = prefs.getBool('public') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadpref();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
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
