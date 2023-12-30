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

  const AchievementsPage({Key? key, required this.userDetails})
      : super(key: key);

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final double _iconSize = 25; // Adjust the icon size as needed
  final double _imageIconSize = 50; // Adjust the image icon size as needed

  // Define the colors for achieved and not achieved icons
  final Color _achievedColor = Colors.green;
  final Color _notAchievedColor = Colors.grey;

  // Define the achievement icons
  final Map<String, IconData> _achievementIcons = {
    'anchor': FontAwesomeIcons.anchor,
    'award': FontAwesomeIcons.award,
    'handFist': FontAwesomeIcons.handFist,
    'handHoldingHeart': FontAwesomeIcons.handHoldingHeart,
    'meteor': FontAwesomeIcons.meteor,
    'sun': FontAwesomeIcons.sun,
  };

  // Track the status of each achievement
  Map<String, bool> _achievementStatus = {};

  @override
  void initState() {
    super.initState();
    // Load the achievement status when the page initializes
    _loadAchievementStatus();
  }

  // Load the achievement status from Firebase
  Future<void> _loadAchievementStatus() async {
    try {
      final achievementStatus = await FirebaseController.getAchievementStatus(
          widget.userDetails.email!);

      setState(() {
        _achievementStatus = achievementStatus;
      });
    } catch (e) {
      print('Error loading achievement status: $e');
    }
  }

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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: SafeArea(
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
                        onPressed: () {
                          _showImagePickerOptions();
                        },
                        icon: CircleAvatar(
                          radius: _imageIconSize,
                          backgroundImage:
                              widget.userDetails.profileAvatarUrl == null ||
                                      widget.userDetails.profileAvatarUrl == ''
                                  ? null
                                  : NetworkImage(
                                      widget.userDetails.profileAvatarUrl!,
                                    ),
                          child: widget.userDetails.profileAvatarUrl == null ||
                                  widget.userDetails.profileAvatarUrl == ''
                              ? Icon(Icons.person_2_outlined,
                                  size: _imageIconSize)
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
                      // Build tiles for each achievement
                      _buildAchievementTile('anchor',
                          'To unlock this achievement complete 10000 meters of bicycle riding.'),
                      _buildAchievementTile('handFist',
                          'To unlock this achievement go on 6 different cycling explorations.'),
                      _buildAchievementTile('sun',
                          'To unlock this achievement go on a bicycle ride early in the morning.'),
                      _buildAchievementTile('meteor',
                          'To unlock this achievement complete 2000 meters bicycle ride in less than 2 hours.'),
                      _buildAchievementTile('handHoldingHeart',
                          'To unlock this achievement log in for 30 days.'),
                      _buildAchievementTile(
                          'award', 'Complete all Achievements'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build an achievement tile with an icon and description
  Widget _buildAchievementTile(String achievementName, String description) {
    // Determine if the achievement is achieved
    final bool isAchieved = _achievementStatus[achievementName] ?? false;

    // Determine the color based on the achievement status
    final Color iconColor = isAchieved ? _achievedColor : _notAchievedColor;

    return ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: FaIcon(
        _achievementIcons[achievementName],
        size: _iconSize,
        color: iconColor,
      ),
      title: Text(description),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? file;

    try {
      file = await _picker.pickImage(
        source: source,
        imageQuality: 50,
      );
    } catch (e) {
      print('Error picking image: $e');
    }

    if (file != null) {
      String fileExtension = file.name.substring(file.name.indexOf('.'));
      String fileName =
          "${FirebaseAuth.instance.currentUser!.email}_profileAvatar$fileExtension";

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload = referenceDirImages.child(fileName);

      try {
        String? imageUrl;
        await referenceImageToUpload.putFile(File(file.path));
        imageUrl = await referenceImageToUpload.getDownloadURL();

        // Use setState to trigger a rebuild of the widget
        setState(() {
          widget.userDetails.profileAvatarUrl = imageUrl;
        });

        FirebaseController.createAndUpdateUser(
          widget.userDetails,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Your avatar has been updated!',
            ),
            duration: Duration(seconds: 1),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error has occurred | More Info: $e',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showImagePickerOptions() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
