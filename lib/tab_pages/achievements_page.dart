import 'dart:io';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AchievementsPage extends StatelessWidget {
  final UserDetails userDetails;

  const AchievementsPage({super.key, required this.userDetails});
  @override
  Widget build(BuildContext context) {
    String imageUrl;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                XFile? file =
                    await picker.pickImage(source: ImageSource.gallery);
                String fileName =
                    "${FirebaseAuth.instance.currentUser!.email}_profileAvatar";

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');

                Reference referenceImageToUpload =
                    referenceDirImages.child(fileName);

                try {
                  await referenceImageToUpload
                      .putFile(File(file!.path)); // store the file
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                  // get the link

                  userDetails.profileAvatarUrl = imageUrl;

                  FirebaseController fc = FirebaseController();
                  fc.CreateAndUpdateUser(userDetails);
                } catch (e) {} // todo
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
