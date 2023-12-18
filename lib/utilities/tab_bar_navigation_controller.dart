import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cycletech/tab_pages/home_page.dart';
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
  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.leaderboard_outlined,
    Icons.person_outline,
    Icons.settings_outlined,
  ];

  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
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
