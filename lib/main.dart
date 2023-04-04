import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oobacht/utils/auth_wrapper.dart';
import 'package:oobacht/utils/map_utils.dart';
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

  // Register to receive BackgroundFetch events after app is terminated.
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

// [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    BackgroundFetch.finish(taskId);
    return;
  }
  await startPositionListener();
  BackgroundFetch.finish(taskId);
}

Future<void> startPositionListener() async {
  Position? position = await getCurrentPosition(null);
  if (position != null) {
    sendPositionToFirebase(position.latitude, position.longitude);
  }

}

void sendPositionToFirebase(double latitude, double longitude) async {
  print('>>> DEBUG Position: $latitude, $longitude');
  // TODO PK send position to firebase
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
    startPositionListener();
    initPlatformState();
    BackgroundFetch.start();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/logo.png"), context);
    return MaterialApp(
      title: 'OObacht!',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      home: const AuthWrapper(),
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

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY
    ), (String taskId) async {  // <-- Event handler
      await startPositionListener();
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // This task has exceeded its allowed running-time.
      BackgroundFetch.finish(taskId);
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
}
