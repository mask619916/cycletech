import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  static Future<UserDetails> readUserInfo() async {
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

  static void createAndUpdateUser(UserDetails userDetails) {
    DocumentReference dr = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.email);

    dr.set(userDetails.toMap());
  }

  static Future<Map<String, bool>> getAchievementStatus(
      String userEmail) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users') // Change this to 'users' collection
              .doc(userEmail)
              .get();

      if (snapshot.exists) {
        // Assuming 'achievements' is the field in the 'users' document
        final Map<String, bool> achievements =
            Map<String, bool>.from(snapshot.data()?['achievements'] ?? {});
        return achievements;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting achievement status: $e');
      throw e;
    }
  }

  static Future<void> updateAchievementStatus(
      String userEmail, Map<String, bool> newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('achievements')
          .doc(userEmail)
          .set(newStatus);
    } catch (e) {
      print('Error updating achievement status: $e');
      throw e;
    }
  }

  static Future<double> getHighestDistance({required String userEmail}) async {
    double highestDistance = 0.0;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('trackedRides')
        .get();

    for (final doc in querySnapshot.docs) {
      final distance = double.parse(doc['distance'].toString());

      if (distance > highestDistance) {
        highestDistance = distance;
      }
    }

    return highestDistance;
  }

  static Future<Duration> getLongestRide({required String userEmail}) async {
    Duration highestDuration = Duration();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('trackedRides')
        .get();

    for (final doc in querySnapshot.docs) {
      final String timeElapsed = doc['timeElapsed'];
      final List<String> timeParts = timeElapsed.split(':');
      final int hours = int.parse(timeParts[0]);
      final int mins = int.parse(timeParts[1]);

      Duration duration = Duration(hours: hours, minutes: mins);

      if (duration > highestDuration) {
        highestDuration = duration;
      }
    }

    return highestDuration;
  }
}
