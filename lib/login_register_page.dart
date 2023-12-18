import 'package:cycletech/utilities/auth.dart';
import 'package:cycletech/components/custom_text_field.dart';
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

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
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
                      onPressed: () {},
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
