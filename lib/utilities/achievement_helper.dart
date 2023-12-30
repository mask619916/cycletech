import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementHelper {
  static void checkAndUpdateAchievements({
    required String userEmail,
    required List<GeoPoint> coordinates,
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
        // Use double.tryParse to handle cases where 'distance' is stored as a string
        final distance = double.tryParse(doc['distance'].toString()) ?? 0.0;
        totalDistance += distance;
      }
    } catch (e) {
      print('Error fetching total distance: $e');
    }

    return totalDistance;
  }
}
