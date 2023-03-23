import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oobacht/screens/login/login_screen.dart';
import 'package:oobacht/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase_options.dart';

Future<void> main() async {
  //Firebase Connection
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const OobachtApp());
}

class OobachtApp extends StatefulWidget {
  const OobachtApp({super.key});

  @override
  State<OobachtApp> createState() => _OobachtAppState();
}

class _OobachtAppState extends State<OobachtApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
    loadDataFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/logo.png"), context);
    return MaterialApp(
      title: 'OObacht!',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      home: const LoginScreen(),
      //debugShowCheckedModeBanner: false,
    );
  }

  void loadDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('darkMode') != null) {
        //standard is LightMode, if DarkMode is true toggle theme
        if (prefs.getBool('darkMode') == true) currentTheme.toggleTheme();
      }
    });
  }
}
