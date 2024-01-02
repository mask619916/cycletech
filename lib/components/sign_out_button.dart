// Import necessary packages and files
import 'package:cycletech/utilities/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// SignOutButton widget
class SignOutButton extends StatelessWidget {
  SignOutButton({super.key});

  final User? user = Auth().currentUser; // Get the current user

  @override
  Widget build(BuildContext context) {
    // Build method for the widget
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Display email information in a row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontSize: 16),
            ),
            // Display user's email using a Chip widget
            Chip(
              label: Text(
                user?.email ?? "Not logged in",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        // Display a button to sign out
        FilledButton.tonal(
          onPressed: () async => await Auth().signOut(),
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}
