import 'package:cycletech/tab_pages/login_register_page.dart';
import 'package:cycletech/utilities/auth.dart';
import 'package:cycletech/utilities/tab_bar_navigation_controller.dart';
import 'package:flutter/material.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const TabBarNavigationController();
        } else {
          return const LoginRegisterPage();
        }
      },
    );
  }
}
