// Import necessary packages and files
import 'package:cycletech/utilities/login_controller.dart';
import 'package:flutter/material.dart';

// Define the SplashScreen class as a StatefulWidget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // Create the state for the SplashScreen
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Define the state for the SplashScreen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Schedule a delayed operation to navigate to the LoginController after 3 seconds
    Future.delayed(
      const Duration(seconds: 3),
      () {
        // Navigate to the LoginController and remove the splash screen from the navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginController()),
          (route) => false,
        );
      },
    );

    // Call the initState method of the superclass
    super.initState();
  }

  // Build method for the widget
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the CycleTech logo image
            SizedBox(
              height: 200,
              width: 200,
              child: Image(image: AssetImage("assets/cycle_tech1.png")),
            ),
            // Display the welcome message
            Text(
              "Welcome to CycleTech",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
