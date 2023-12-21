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
    double iconsize = 50;
    return Scaffold(
      appBar: AppBar(
        title: Text("Achivements"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Edit"),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        radius: iconsize,
                        child: IconButton(
                          onPressed: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? file = await picker.pickImage(
                                source: ImageSource.gallery);
                            String fileName =
                                "${FirebaseAuth.instance.currentUser!.email}_profileAvatar";

                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');

                            Reference referenceImageToUpload =
                                referenceDirImages.child(fileName);

                            try {
                              await referenceImageToUpload
                                  .putFile(File(file!.path)); // store the file
                              imageUrl =
                                  await referenceImageToUpload.getDownloadURL();
                              // get the link

                              userDetails.profileAvatarUrl = imageUrl;

                              FirebaseController fc = FirebaseController();
                              fc.CreateAndUpdateUser(userDetails);
                            } catch (e) {} // todo
                          },
                          icon: Icon(
                            Icons.person_2_outlined,
                            size: iconsize,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        Text("name1"),
                        Text("name1"),
                        Text("name1"),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
              ListTile(leading: Icon(Icons.ac_unit), title: Text("pussio fam")),
            ],
          ),
        ),
      ),
    );
  }
}
