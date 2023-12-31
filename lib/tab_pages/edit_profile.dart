import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycletech/components/dropmenu.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/components/custom_text_field.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.userDetails});

  final UserDetails userDetails;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // This is mainly for the keyboard making the functionality of IOS keyboard better
  final TextEditingController _controllerFname = TextEditingController();
  final TextEditingController _controllerLname = TextEditingController();
  final TextEditingController _controllerWeight = TextEditingController();
  final TextEditingController _controllerHeight = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();

  void _updateUserInfo() {
    UserDetails ud = UserDetails(
      email: widget.userDetails.email,
      fName: _controllerFname.text,
      lName: _controllerLname.text,
      weight: int.parse(_controllerWeight.text),
      height: int.parse(_controllerHeight.text),
      gender: selectedGender,
      dob: Timestamp.fromDate(DateTime.parse(_controllerDob.text)),
      isPrivate: widget.userDetails.isPrivate,
      achievements: widget.userDetails.achievements,
    );
    FirebaseController.createAndUpdateUser(ud);
    Navigator.pop(context, ud);
  }

// this is a function to create the calender for the date picker in the registration
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    _controllerDob.text = selectedDate.toString().substring(0, 10);
  }

  @override
  void initState() {
    super.initState();

    DateTime dob = widget.userDetails.dob?.toDate() ?? DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(dob);

    _controllerFname.text = widget.userDetails.fName ?? '';
    _controllerLname.text = widget.userDetails.lName ?? '';
    _controllerHeight.text = widget.userDetails.height.toString();
    _controllerWeight.text = widget.userDetails.weight.toString();
    _controllerDob.text = formattedDate;
    selectedGender = widget.userDetails.gender ?? "male";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 75),

                // Circle Icon
                CircleAvatar(
                  radius: 100,
                  backgroundImage:
                      NetworkImage(widget.userDetails.profileAvatarUrl ?? ''),
                  child: widget.userDetails.profileAvatarUrl == null
                      ? Icon(
                          Icons.person_outline,
                          size: 100,
                        )
                      : null,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //first name input

                    CustomTextField(
                      title: 'First Name',
                      type: TextFieldType.normal,
                      controller: _controllerFname,
                    ),
                    //last name input

                    CustomTextField(
                      title: 'Last Name',
                      type: TextFieldType.normal,
                      controller: _controllerLname,
                    ),
                    //height input
                    CustomTextField(
                      title: 'Height',
                      type: TextFieldType.number,
                      controller: _controllerHeight,
                    ),
                    //weight input
                    CustomTextField(
                      title: 'Weight',
                      type: TextFieldType.number,
                      controller: _controllerWeight,
                    ),
                    //Date of birth input
                    CustomTextField(
                      title: 'Date Of Birth',
                      type: TextFieldType.readonly,
                      controller: _controllerDob,
                      trailing: IconButton(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ),

                    // Gender input
                    DropdownExample()
                  ],
                ),

                // Submit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateUserInfo(),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
