import 'package:cycletech/components/sign_out_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text("Home page"),
            SignOutButton(),
          ],
        ),
      ),
    );
  }
}
