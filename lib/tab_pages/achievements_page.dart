import 'dart:io';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AchievementsPage extends StatefulWidget {
  final UserDetails userDetails;

  const AchievementsPage({super.key, required this.userDetails});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final double _iconSize = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Edit"),
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
                      child: IconButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();

                          XFile? file = await picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          String fileExtension =
                              file!.name.substring(file.name.indexOf('.'));

                          String fileName =
                              "${FirebaseAuth.instance.currentUser!.email}_profileAvatar$fileExtension";

                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();

                          Reference referenceDirImages =
                              referenceRoot.child('images');

                          Reference referenceImageToUpload =
                              referenceDirImages.child(fileName);

                          try {
                            String? imageUrl;

                            await referenceImageToUpload
                                .putFile(File(file.path)); // store the file

                            imageUrl = await referenceImageToUpload
                                .getDownloadURL(); // get the link

                            widget.userDetails.profileAvatarUrl = imageUrl;

                            FirebaseController.createAndUpdateUser(
                              widget.userDetails,
                            );

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Your avatar has been updated!',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'An error has occurred | More Info: $e',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        icon: CircleAvatar(
                          radius: _iconSize,
                          backgroundImage:
                              widget.userDetails.profileAvatarUrl == null ||
                                      widget.userDetails.profileAvatarUrl == ''
                                  ? null
                                  : NetworkImage(
                                      widget.userDetails.profileAvatarUrl!,
                                    ),
                          child: widget.userDetails.profileAvatarUrl == null ||
                                  widget.userDetails.profileAvatarUrl == ''
                              ? Icon(Icons.person_2_outlined, size: _iconSize)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userDetails.fName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.userDetails.lName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.userDetails.gender ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
