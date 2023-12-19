import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  Future<UserDetails> readUserInfo() async {
    DocumentReference dr = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email);

    Map<String, dynamic> userDetailsMap = await dr.get().then((value) {
      return value.data() as Map<String, dynamic>;
    });

    return UserDetails(
      email: FirebaseAuth.instance.currentUser!.email,
      achievements: userDetailsMap['achievements'],
      dob: userDetailsMap['dob'],
      fName: userDetailsMap['fName'],
      lName: userDetailsMap['lName'],
      gender: userDetailsMap['gender'],
      height: userDetailsMap['height'],
      profileAvatarUrl: userDetailsMap['profileAvatarUrl'],
      weight: userDetailsMap['weight'],
    );
  }

  void CreateAndUpdateUser(UserDetails userDetails) {
    DocumentReference dr = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email);

    dr.set(userDetails.tomap());
  }
}
