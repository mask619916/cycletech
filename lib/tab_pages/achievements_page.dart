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
        title: const Text("Profile"),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        // Add your image picker logic here
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
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Achievements",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: FaIcon(FontAwesomeIcons.anchor),
                      title: Text(
                          "To unlock this achievement complete 10km of bicycle riding."),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: FaIcon(FontAwesomeIcons.handFist),
                      title: Text(
                          "To unlock this achievement go on 6 different cycling explorations."),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: FaIcon(FontAwesomeIcons.sun),
                      title: Text(
                          "To unlock this achievement go on a bicycle ride early in the morning."),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: FaIcon(FontAwesomeIcons.meteor),
                      title: Text(
                          "To unlock this achievement complete 2km bicycle ride in less than 2 hours."),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: FaIcon(FontAwesomeIcons.handHoldingHeart),
                      title: Text(
                          "To unlock this achievement log in for 30 days."),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: FaIcon(FontAwesomeIcons.award),
                      title: Text("Complete all Achievements"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
