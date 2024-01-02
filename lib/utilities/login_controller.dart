// Importing necessary packages and files
import 'package:cycletech/tab_pages/login_register_page.dart';
import 'package:cycletech/utilities/auth.dart';
import 'package:cycletech/utilities/tab_bar_navigation_controller.dart';
import 'package:flutter/material.dart';

// Define a widget to handle the login state and navigation
class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => _LoginControllerState();
}

// Define the state for the login controller widget
class _LoginControllerState extends State<LoginController> {
  @override
  Widget build(BuildContext context) {
    // Use a StreamBuilder to listen to authentication state changes
    return StreamBuilder(
      stream: Auth().authStateChanges, // The stream of authentication state changes
      builder: (context, snapshot) {
        // Check if there is authenticated user data
        if (snapshot.hasData) {
          // If authenticated, navigate to the main TabBarNavigationController
          return const TabBarNavigationController();
        } else {
          // If not authenticated, show the LoginRegisterPage for user login/registration
          return const LoginRegisterPage();
        }
      },
    );
  }
}
