import 'package:cycletech/utilities/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  SignOutButton({super.key});

  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontSize: 16),
            ),
            Chip(
              label: Text(
                user?.email ?? "Not logged in",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        FilledButton.tonal(
          onPressed: () async => await Auth().signOut(),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
