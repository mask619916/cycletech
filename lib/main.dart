import 'package:cycletech/firebase_options.dart';
import 'package:cycletech/globals/globaldata.dart';
import 'package:cycletech/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('darkMode') ?? false;
    // bool isPublic = prefs.getBool('public') ?? false; // May be required later on

    Brightness temp = isDarkMode ? Brightness.dark : Brightness.light;
    brightnessStream.add(temp);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getPrefs();

    return StreamBuilder<Brightness>(
        initialData: Brightness.light,
        stream: brightnessStream.stream,
        builder: (context, snapshot) {
          currBrightness = snapshot.data;
          return MaterialApp(
            title: 'Cycle Tech',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                brightness: snapshot.data ?? Brightness.light,
                seedColor: Colors.blue.shade100,
              ),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        });
  }
}
