import 'package:cycletech/globals/globaldata.dart';
import 'package:flutter/material.dart';

class LeaderboardsPage extends StatelessWidget {
  const LeaderboardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboards'),
          backgroundColor: currBrightness == Brightness.dark
              ? Colors.black54
              : Colors.blue[100],
          foregroundColor:
              currBrightness == Brightness.dark ? Colors.white : Colors.black54,
          bottom: TabBar(
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
              // Daily Leaderboard Placeholder
              LeaderboardTab(title: 'Daily'),

              // Weekly Leaderboard Placeholder
              LeaderboardTab(title: 'Weekly'),

              // All Time Leaderboard Placeholder
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Placeholder content for the leaderboard
          ListTile(
            leading: Icon(Icons.star),
            title: Text('First Place'),
          ),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('Second Place'),
          ),
          ListTile(
            leading: Icon(Icons.star_border),
            title: Text('Third Place'),
          ),
          // Add more list entries as needed
          // ...
        ],
      ),
    );
  }
}
