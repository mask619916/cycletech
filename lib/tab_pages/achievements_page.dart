import 'dart:io';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        backgroundColor: currBrightness == Brightness.dark
            ? Colors.black54
            : Colors.blue[100],
        foregroundColor:
            currBrightness == Brightness.dark ? Colors.white : Colors.black54,
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
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.anchor),
                  title: Text(
                      "To unlock this achievement complete 10km of bicycle riding.")),
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.handFist),
                  title: Text(
                      "To unlock this achievement go on 6 different cycling explorations.")),
              ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.sun,
                  ),
                  title: Text(
                      "To unlock this achievement go on a bicycle ride early in the morning.")),
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.meteor),
                  title: Text(
                      "To unlock this achievement complete 2km bicycle ride in less than 2 hours.")),
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.handHoldingHeart),
                  title:
                      Text("To unlock this achievement log in for 30 days.")),
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.award),
                  title: Text("Complete all Achievements")),
            ],
          ),
        ),
      ),
    );
  }
}
