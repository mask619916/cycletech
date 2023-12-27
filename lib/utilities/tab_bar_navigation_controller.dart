import 'dart:async';
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
import '../utilities/quote_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class TabBarNavigationController extends StatefulWidget {
  const TabBarNavigationController({Key? key}) : super(key: key);

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

  late UserDetails _userDetails;
  late List<Widget> _pagesList;
  late Widget _currPage;
  int _bottomNavIndex = 0;

  String _quoteOfTheDay = '';
  int _countdownInSeconds = 50;
  late Timer _quoteTimer;
  late bool _isVisible;

  // Quote stuff
  void _setupQuoteTimer() {
    _quoteTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_countdownInSeconds == 0) {
          _countdownInSeconds = 50;

          if (_isVisible &&
              SchedulerBinding.instance.lifecycleState ==
                  AppLifecycleState.resumed) {
            _updateQuoteOfTheDay();
          }
        } else {
          _countdownInSeconds--;
        }

        print("${_countdownInSeconds} seconds until quote update check");
      },
    );
  }

  void _updateQuoteOfTheDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // print("Forcing Update Quote of the Day...");

    String quoteKey = 'quote_of_the_day';

    DateTime now = DateTime.now();
    // print("${now.hour}h:${now.minute}m");
    if (now.hour == 8 && now.minute == 0) {
      // Generate a new quote and save it
      String newQuote = getRandomQuote();
      prefs.setString(quoteKey, newQuote);

      // Check if the widget is still mounted
      if (!mounted) return;

      setState(() {
        // print("Setting state with new quote: $newQuote");
        _quoteOfTheDay = newQuote;
      });
    } else {
      // reading quote from local storage
      String loadedQuote = prefs.getString(quoteKey) ?? "";

      // Check if the widget is still mounted
      if (!mounted) return;

      setState(() {
        // print("Setting state with new quote: $loadedQuote");
        _quoteOfTheDay = loadedQuote;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    _setupQuoteTimer();
    _updateQuoteOfTheDay();

    _userDetails = UserDetails();
    _currPage = Container();

    // read user's info from firebase
    FirebaseController.readUserInfo().then((value) {
      setState(() {
        _userDetails = value;
        _pagesList[2] = AchievementsPage(userDetails: _userDetails);
        _currPage = _pagesList[_bottomNavIndex];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _quoteTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _pagesList = [
      HomePage(quoteOfTheDay: _quoteOfTheDay),
      const LeaderboardsPage(),
      AchievementsPage(userDetails: _userDetails),
      SettingsPage(
        onDarkModeChanged: (isDarkMode) {
          setState(() {
            _bottomNavIndex = 3 % _pagesList.length;
          });
        },
      ),
      const GoPage(),
    ];

    return Scaffold(
      body: _currPage,
      floatingActionButton: SizedBox(
        height: 75,
        width: 75,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _bottomNavIndex = 4;
              _currPage = _pagesList[_bottomNavIndex];
            });
          },
          backgroundColor: currBrightness == Brightness.dark
              ? Colors.green[400]
              : Colors.greenAccent,
          splashColor: Colors.cyan[200],
          foregroundColor:
              currBrightness == Brightness.dark ? Colors.white : Colors.black87,
          shape: const CircleBorder(),
          child: const FaIcon(FontAwesomeIcons.personBiking),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _iconList.length,
        backgroundColor: currBrightness == Brightness.dark
            ? Colors.black54
            : Colors.blue[100],
        tabBuilder: (int index, bool isActive) {
          return Icon(
            _iconList[index],
            size: 24,
            color: isActive
                ? Colors.green[400]
                : currBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
          );
        },
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index % _pagesList.length;
            _currPage = _pagesList[_bottomNavIndex];
          });
        },
      ),
    );
  }
}
