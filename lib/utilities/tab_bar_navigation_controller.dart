import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cycletech/globals/globaldata.dart';
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
  final List<IconData> _iconList = [
    Icons.home_outlined,
    Icons.leaderboard_outlined,
    Icons.person_outline,
    Icons.settings_outlined,
  ];
  final List<Widget> _pagesList = [];

  UserDetails _userDetails = UserDetails();
  Widget _currPage = const HomePage();
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    // read user's info from firebase
    FirebaseController.readUserInfo().then((value) => _userDetails = value);

    _pagesList.clear();
    _pagesList.addAll([
      const HomePage(),
      const LeaderboardsPage(),
      AchievementsPage(userDetails: _userDetails),
      const SettingsPage(),
      const GoPage(),
    ]);

    setState(() {
      _currPage = _pagesList[_bottomNavIndex];
    });

    return Scaffold(
      body: _currPage,
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
          foregroundColor: Colors.black87,
          shape: const CircleBorder(),
          child: const FaIcon(FontAwesomeIcons.personBiking),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _iconList.length,
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black87
                : Colors.blue[100],
        tabBuilder: (int index, bool isActive) {
          return Icon(
            _iconList[index],
            size: 24,
            color: isActive ? Colors.green[400] : Colors.black87,
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
