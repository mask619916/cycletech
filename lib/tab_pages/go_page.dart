import 'package:flutter/material.dart';

class GoPage extends StatelessWidget {
  const GoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Go page"),
          ],
        ),
      ),
    );
  }
}
