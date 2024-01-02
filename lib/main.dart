// Import necessary packages and files
import 'package:cycletech/firebase_options.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Asynchronous main function to initialize the app
Future<void> main() async {
  // Ensure that widgets are initialized before runApp is called
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

// Define the main application class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Function to retrieve and set preferences
  void getPrefs() async {
    // Obtain an instance of SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve dark mode preference from SharedPreferences, default to false
    bool isDarkMode = prefs.getBool('darkMode') ?? false;

    // Retrieve public mode preference from SharedPreferences (commented out for future use)
    // bool isPublic = prefs.getBool('public') ?? false;

    // Determine the brightness based on the dark mode preference
    Brightness temp = isDarkMode ? Brightness.dark : Brightness.light;

    // Add the brightness value to the stream
    brightnessStream.add(temp);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Call the getPrefs function to set initial preferences
    getPrefs();

    // Build the main application using StreamBuilder to react to brightness changes
    return StreamBuilder<Brightness>(
      initialData: Brightness.light,
      stream: brightnessStream.stream,
      builder: (context, snapshot) {
        // Update the current brightness value
        currBrightness = snapshot.data;

        // Return the MaterialApp widget with the specified title, theme, and home
        return MaterialApp(
          title: 'Cycle Tech',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              brightness: snapshot.data ?? Brightness.light,
              seedColor: Colors.blue.shade100,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
