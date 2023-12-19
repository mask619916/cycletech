import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cycletech/models/user_details.dart';
import 'package:cycletech/tab_pages/achievements_page.dart';
import 'package:cycletech/tab_pages/go_page.dart';
import 'package:cycletech/tab_pages/home_page.dart';
import 'package:cycletech/tab_pages/leaderboards_page.dart';
import 'package:cycletech/tab_pages/settings_page.dart';
import 'package:cycletech/utilities/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabBarNavigationController extends StatefulWidget {
  const TabBarNavigationController({super.key});

  @override
  State<TabBarNavigationController> createState() =>
      _TabBarNavigationControllerState();
}

class _TabBarNavigationControllerState
    extends State<TabBarNavigationController> {
  FirebaseController fc = FirebaseController();

  UserDetails userDetails = UserDetails();

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.leaderboard_outlined,
    Icons.person_outline,
    Icons.settings_outlined,
  ];

  List<Widget> pagesList = [];

  int _bottomNavIndex = 0;

  void loadUserInfo() {
    fc.readUserInfo().then((value) => userDetails = value);
  }

  @override
  Widget build(BuildContext context) {
    loadUserInfo();

    pagesList.addAll([
      const HomePage(),
      const LeaderboardsPage(),
      AchievementsPage(userDetails: userDetails),
      const SettingsPage(),
      const GoPage(),
    ]);

    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: pagesList,
      ),
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _bottomNavIndex = 4;
            });
          },
          backgroundColor: Colors.greenAccent,
          splashColor: Colors.cyan[200],
          shape: const CircleBorder(),
          child: const FaIcon(FontAwesomeIcons.personBiking),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        backgroundColor: Colors.black54,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            iconList[index],
            size: 24,
            color: isActive ? Colors.green[400] : Colors.white,
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
      ),
    );
  }
}
