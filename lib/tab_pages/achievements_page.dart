import 'package:cycletech/models/user_details.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AchievementsPage extends StatelessWidget {
  final UserDetails userDetails;

  const AchievementsPage({super.key, required this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                XFile? file =
                    await picker.pickImage(source: ImageSource.camera);
              },
              icon: const Icon(
                Icons.photo_album_outlined,
                size: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
