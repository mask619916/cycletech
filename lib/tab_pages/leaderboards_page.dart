import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:flutter/material.dart';

class LeaderboardsPage extends StatelessWidget {
  const LeaderboardsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Daily, Weekly, All Time
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboards'),
          backgroundColor: currBrightness == Brightness.dark
              ? Colors.black54
              : Colors.blue[100],
          foregroundColor:
              currBrightness == Brightness.dark ? Colors.white : Colors.black54,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'All Time'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              LeaderboardTab(title: 'Daily'),
              LeaderboardTab(title: 'Weekly'),
              LeaderboardTab(title: 'All Time'),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderboardTab extends StatelessWidget {
  final String title;

  const LeaderboardTab({Key? key, required this.title}) : super(key: key);

  Future<List<QueryDocumentSnapshot>> fetchUsersWithRides(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    var userData = <QueryDocumentSnapshot>[];

    for (var user in snapshot.docs) {
      if (await hasRidesForPeriod(user, title)) {
        userData.add(user);
      }
    }

    return userData;
  }

  Future<bool> hasRidesForPeriod(
      QueryDocumentSnapshot user, String period) async {
    var today = DateTime.now();
    var trackedRidesCollection = user.reference.collection('trackedRides');
    QuerySnapshot<Map<String, dynamic>> ridesForPeriod;

    if (period == 'Daily') {
      ridesForPeriod = await trackedRidesCollection
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime(today.year, today.month, today.day).toUtc())
          .where('date',
              isLessThan:
                  DateTime(today.year, today.month, today.day + 1).toUtc())
          .get();
    } else if (period == 'Weekly') {
      // Adjust this logic based on how you define a "week" in your app
      var weekStart = today.subtract(Duration(days: today.weekday - 1));
      var weekEnd = weekStart.add(Duration(days: 7));

      ridesForPeriod = await trackedRidesCollection
          .where('date', isGreaterThanOrEqualTo: weekStart.toUtc())
          .where('date', isLessThan: weekEnd.toUtc())
          .get();
    } else {
      // 'All Time': Retrieve all rides without date filtering
      ridesForPeriod = await trackedRidesCollection.get();
    }

    return ridesForPeriod.docs.isNotEmpty;
  }

  Future<List<double>> fetchData(List<QueryDocumentSnapshot> userData) async {
    var distances = await Future.wait<double>(
      (userData ?? []).map<Future<double>>(
        (user) => _calculateTotalDistanceForRides(user.reference),
      ),
    );

    return distances;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error in user stream: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }

        return FutureBuilder<List<QueryDocumentSnapshot>>(
          future: fetchUsersWithRides(snapshot.data!),
          builder: (context, usersSnapshot) {
            if (usersSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var userData = usersSnapshot.data;

            if (userData == null) {
              // Return some default widget or message when userData is null
              return Text('No data available');
            }

            return FutureBuilder<List<double>>(
              future: fetchData(userData),
              builder: (context, distancesSnapshot) {
                if (distancesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (distancesSnapshot.hasError) {
                  print('Error fetching distances: ${distancesSnapshot.error}');
                  return Text('Error: ${distancesSnapshot.error}');
                }

                var distances = distancesSnapshot.data;

                if (distances == null) {
                  // Return some default widget or message when distances is null
                  return Text('No data available');
                }

                var combinedData = List.generate(userData.length, (index) {
                  var user = userData[index];
                  var distance = distances[index];
                  return {'user': user, 'distance': distance};
                });

                combinedData.sort((a, b) {
                  var distanceA = (a['distance'] as double?) ?? double.infinity;
                  var distanceB = (b['distance'] as double?) ?? double.infinity;
                  return distanceB.compareTo(distanceA);
                });

                return ListView.builder(
                  itemCount: combinedData.length,
                  itemBuilder: (context, index) {
                    var user = combinedData[index]['user'];
                    var distance = combinedData[index]['distance'];

                    IconData? prefixIcon;
                    if (index == 0) {
                      prefixIcon = Icons.star; // First place
                    } else if (index == 1) {
                      prefixIcon = Icons.star_half; // Second place
                    } else if (index == 2) {
                      prefixIcon = Icons.star_border; // Third place
                    }

                    return ListTile(
                      leading: prefixIcon != null
                          ? Icon(prefixIcon, color: Colors.amber)
                          : null, // Show icon only for the top three places
                      title: Text(
                        '${(user as QueryDocumentSnapshot<Map<String, dynamic>>).data()?['fName'] ?? ''} ${(user as QueryDocumentSnapshot<Map<String, dynamic>>).data()?['lName'] ?? ''}',
                      ),
                      subtitle: Text('Distance: $distance meters'),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<double> _calculateTotalDistanceForRides(
      DocumentReference userReference) async {
    var trackedRidesCollection = userReference.collection('trackedRides');
    var today = DateTime.now();
    QuerySnapshot<Map<String, dynamic>> rides;

    if (title == 'Daily') {
      rides = await trackedRidesCollection
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime(today.year, today.month, today.day).toUtc())
          .where('date',
              isLessThan:
                  DateTime(today.year, today.month, today.day + 1).toUtc())
          .get();
    } else if (title == 'Weekly') {
      // Adjust this logic based on how you define a "week" in your app
      var weekStart = today.subtract(Duration(days: today.weekday - 1));
      var weekEnd = weekStart.add(Duration(days: 7));

      rides = await trackedRidesCollection
          .where('date', isGreaterThanOrEqualTo: weekStart.toUtc())
          .where('date', isLessThan: weekEnd.toUtc())
          .get();
    } else {
      // 'All Time': Retrieve all rides without date filtering
      rides = await trackedRidesCollection.get();
    }

    var distances = rides.docs.map<double>((ride) {
      var distance = ride['distance'];
      if (distance is num) {
        return distance.toDouble();
      } else if (distance is String) {
        // Try to parse the string as a double
        try {
          return double.parse(distance);
        } catch (e) {
          return 0.0; // Default value if parsing fails
        }
      }
      return 0.0; // Default value if 'distance' is not a num or String
    }).toList();

    return distances.isEmpty
        ? 0.0
        : distances.reduce((sum, distance) => sum + distance);
  }
}
