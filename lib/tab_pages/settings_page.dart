import 'package:cycletech/components/sign_out_button.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onDarkModeChanged;
  final UserDetails userDetails;

  const SettingsPage({
    Key? key,
    required this.onDarkModeChanged,
    required this.userDetails,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables
  bool _isDarkMode = false;
  bool _isPublic = false;
  late String _selectedLocation = "Bahrain"; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    // Load preferences when initializing the state
    loadPrefs();
  }

  // Load preferences from SharedPreferences
  void loadPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _isPublic = prefs.getBool('public') ?? false;
      _selectedLocation = prefs.getString('location') ?? "Bahrain";
    });
  }

  // Save preferences to SharedPreferences and update Firebase user data
  void savePref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('public', _isPublic);
    await prefs.setString('location', _selectedLocation);
    widget.onDarkModeChanged(_isDarkMode);

    // Update Firebase user data
    UserDetails ud = UserDetails(
      email: widget.userDetails.email,
      fName: widget.userDetails.fName,
      lName: widget.userDetails.lName,
      weight: widget.userDetails.weight,
      height: widget.userDetails.height,
      gender: widget.userDetails.gender,
      dob: widget.userDetails.dob,
      achievements: currUserDetails.achievements,
      profileAvatarUrl: widget.userDetails.profileAvatarUrl,
      isPrivate: _isPublic,
    );
    FirebaseController.createAndUpdateUser(ud);
  }

  @override
  Widget build(BuildContext context) {
    // Determine the current brightness (light/dark mode)
    _isDarkMode = (currBrightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: currBrightness == Brightness.dark
            ? Colors.black54
            : Colors.blue[100],
        foregroundColor:
            currBrightness == Brightness.dark ? Colors.white : Colors.black54,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Dark Mode Switch
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
              // Leaderboard Public Privacy Switch
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
              // Location Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Location'),
                  DropdownButton<String>(
                    value: _selectedLocation,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLocation = newValue!;
                      });
                      savePref();
                    },
                    items: [
                      "Bahrain",
                      "Manama",
                      "Madinat Hamad",
                      "Madinat Isa",
                      "Al Muharraq",
                      "Umm ash Sha‘ūm",
                      "Sitrah",
                      "Samāhīj",
                      "Al Hadd",
                      "Dar Kulayb",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              // Sign Out Button
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: SignOutButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
