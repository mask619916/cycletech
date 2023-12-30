import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementHelper {
  static Future<void> checkAndUpdateAchievements({
    required String userEmail,
  }) async {
    try {
      final totalDistance = await _fetchTotalDistance(userEmail);

      if (totalDistance >= 10000) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'achievements.anchor': true});
        print('Achievement updated: Anchor achieved!');
      } else {
        print('Achievement not updated: Distance not sufficient.');
      }

      // Check and update Hand Fist achievement
      await checkAndUpdateHandFistAchievement(userEmail: userEmail);

      // Check and update Sun achievement
      await checkAndUpdateSunAchievement(userEmail: userEmail);

      // Check and update Meteor achievement
      await checkAndUpdateMeteorAchievement(userEmail: userEmail);

      // Check and update Hand Holding Heart achievement
      await checkAndUpdateHandHoldingHeartAchievement(userEmail: userEmail);

      // Check and update Award achievement
      await checkAndUpdateAwardAchievement(userEmail: userEmail);
    } catch (e) {
      print('Error checking and updating achievements: $e');
    }
  }

  static Future<double> _fetchTotalDistance(String userEmail) async {
    double totalDistance = 0.0;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('trackedRides')
          .get();

      for (final doc in querySnapshot.docs) {
        final distance = double.tryParse(doc['distance'].toString()) ?? 0.0;
        totalDistance += distance;
      }
    } catch (e) {
      print('Error fetching total distance: $e');
    }

    return totalDistance;
  }

  static Future<void> checkAndUpdateHandFistAchievement({
    required String userEmail,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('trackedRides')
          .get();

      // Check if there are 6 or more documentIds
      if (querySnapshot.size >= 6) {
        // Update the Hand Fist achievement to true
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'achievements.handFist': true});
        print('Achievement updated: Hand Fist achieved!');
      } else {
        print('Achievement not updated: Insufficient rides.');
      }
    } catch (e) {
      print('Error checking and updating Hand Fist achievement: $e');
    }
  }

  static Future<void> checkAndUpdateSunAchievement({
    required String userEmail,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('trackedRides')
          .get();

      // Check if there is any ride between 5 am and 10 am
      final bool hasMorningRide = querySnapshot.docs.any((doc) {
        final Timestamp rideDate = doc['date'];
        final DateTime rideDateTime = rideDate.toDate();
        final int hour = rideDateTime.hour;

        return hour >= 5 && hour <= 10;
      });

      if (hasMorningRide) {
        // Update the Sun achievement to true
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'achievements.sun': true});
        print('Achievement updated: Sun achieved!');
      } else {
        print('Achievement not updated: No ride between 5 am and 10 am.');
      }
    } catch (e) {
      print('Error checking and updating Sun achievement: $e');
    }
  }

  static Future<void> checkAndUpdateMeteorAchievement({
    required String userEmail,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('trackedRides')
          .get();

      print('Checking for Meteor achievement...');

      // Check if there is any ride with 2000 meters distance in 2 hours or less
      final bool hasMeteorRide = querySnapshot.docs.any((doc) {
        final double distance =
            double.tryParse(doc['distance'].toString()) ?? 0.0;
        final String timeElapsed = doc['timeElapsed'].toString();
        final List<String> timeParts = timeElapsed.split(':');
        final int hours = int.tryParse(timeParts[0]) ?? 0;
        final int minutes = int.tryParse(timeParts[1]) ?? 0;

        print('Ride details: Distance=$distance, Time=$timeElapsed');

        return distance >= 2000 && (hours < 2 || (hours == 2 && minutes == 0));
      });

      if (hasMeteorRide) {
        // Update the Meteor achievement to true
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'achievements.meteor': true});
        print('Achievement updated: Meteor achieved!');
      } else {
        print(
            'Achievement not updated: No ride with 2000 meters in 2 hours or less.');
      }
    } catch (e) {
      print('Error checking and updating Meteor achievement: $e');
    }
  }

  static Future<void> checkAndUpdateHandHoldingHeartAchievement({
    required String userEmail,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('trackedRides')
          .get();

      print('Checking for Hand Holding Heart achievement...');

      // Check if any ride has 4 hours or more
      final bool hasLongRide = querySnapshot.docs.any((doc) {
        final String timeElapsed = doc['timeElapsed'].toString();
        final List<String> timeParts = timeElapsed.split(':');
        final int hours = int.tryParse(timeParts[0]) ?? 0;

        return hours >= 4;
      });

      if (hasLongRide) {
        // Update the Hand Holding Heart achievement to true
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'achievements.handHoldingHeart': true});
        print('Achievement updated: Hand Holding Heart achieved!');
      } else {
        print('Achievement not updated: No ride with 4 hours or more.');
      }
    } catch (e) {
      print('Error checking and updating Hand Holding Heart achievement: $e');
    }
  }

  static Future<void> checkAndUpdateAwardAchievement({
    required String userEmail,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      final achievements = userDoc['achievements'] ?? {};

      if (achievements['anchor'] == true &&
          achievements['sun'] == true &&
          achievements['handHoldingHeart'] == true &&
          achievements['handFist'] == true &&
          achievements['meteor'] == true) {
        // Update the Award achievement to true
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'achievements.award': true});
        print('Achievement updated: Award achieved!');
      } else {
        print('Achievement not updated: Not all achievements are true.');
      }
    } catch (e) {
      print('Error checking and updating Award achievement: $e');
    }
  }
}
