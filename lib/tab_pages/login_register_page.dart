import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycletech/components/dropmenu.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/utilities/auth.dart';
import 'package:cycletech/components/custom_text_field.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:cycletech/utilities/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;

  // This is mainly for the keyboard making the functionality of IOS keyboard better
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerFname = TextEditingController();
  final TextEditingController _controllerLname = TextEditingController();
  final TextEditingController _controllerWeight = TextEditingController();
  final TextEditingController _controllerHeight = TextEditingController();
  final TextEditingController _controllerDob = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == "INVALID_LOGIN_CREDENTIALS") {
          errorMessage = "Invalid user email or password";
        } else {
          errorMessage = e.message;
        }
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      UserDetails ud = UserDetails(
        email: _controllerEmail.text,
        fName: _controllerFname.text,
        lName: _controllerLname.text,
        weight: int.parse(_controllerWeight.text),
        height: int.parse(_controllerHeight.text),
        gender: selectedGender,
        dob: Timestamp.fromDate(DateTime.parse(_controllerDob.text)),
      );
      FirebaseController.createAndUpdateUser(ud);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == "INVALID_LOGIN_CREDENTIALS") {
          errorMessage = "Invalid user email or password";
        } else {
          errorMessage = e.message;
        }
      });
    }
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLogin ? 'Login' : 'Register'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            // scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 75),

                // Circle Icon
                const CircleAvatar(
                  radius: 100,
                  child: Icon(
                    Icons.person_2_outlined,
                    size: 100,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email text field
                    CustomTextField(
                      title: 'Email',
                      type: TextFieldType.normal,
                      controller: _controllerEmail,
                    ),

                    // Password text field
                    CustomTextField(
                      title: 'Password',
                      type: TextFieldType.password,
                      controller: _controllerPassword,
                    ),

                    //first name input
                    isLogin
                        ? Container()
                        : CustomTextField(
                            title: 'First Name',
                            type: TextFieldType.normal,
                            controller: _controllerFname,
                          ),
                    //last name input
                    isLogin
                        ? Container()
                        : CustomTextField(
                            title: 'Last Name',
                            type: TextFieldType.normal,
                            controller: _controllerLname,
                          ),
                    //height input
                    isLogin
                        ? Container()
                        : CustomTextField(
                            title: 'Height',
                            type: TextFieldType.number,
                            controller: _controllerHeight,
                          ),
                    //weight input
                    isLogin
                        ? Container()
                        : CustomTextField(
                            title: 'Weight',
                            type: TextFieldType.number,
                            controller: _controllerWeight,
                          ),
                    //Date of birth input
                    isLogin
                        ? Container()
                        : CustomTextField(
                            title: 'Date Of Birth',
                            type: TextFieldType.readonly,
                            controller: _controllerDob,
                            trailing: IconButton(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(Icons.calendar_month_outlined),
                            ),
                          ),

                    // Gender input
                    isLogin ? Container() : DropdownExample()
                  ],
                ),

                // Display error message (if any)
                Text(errorMessage == '' ? '' : '$errorMessage'),

                // Submit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: isLogin
                          ? signInWithEmailAndPassword
                          : createUserWithEmailAndPassword,
                      child: Text(isLogin ? 'Login' : 'Register'),
                    ),
                    ElevatedButton(
                      onPressed: () => GoogleAuth().signInWithGoogle(),
                      child: const Row(
                        children: [
                          FaIcon(FontAwesomeIcons.google),
                          SizedBox(width: 10),
                          Text("Google"),
                        ],
                      ),
                    ),
                  ],
                ),

                // Switch to Login or Register button
                TextButton(
                  onPressed: () {
                    setState(() => isLogin = !isLogin);
                  },
                  child: Text(isLogin ? 'Register instead' : 'Login instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
