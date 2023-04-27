import 'package:background_fetch/background_fetch.dart';
import 'package:context_holder/context_holder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/firebase/functions/user_functions.dart';
import 'package:oobacht/logic/services/pushnotificationsservice.dart';
import 'package:oobacht/utils/location_permission_wrapper.dart';
import 'package:oobacht/utils/map_utils.dart';
import 'package:oobacht/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oobacht/globals.dart' as globals;

import 'firebase/firebase_options.dart';

Future<void> main() async {
  //Firebase Connection
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MaterialApp(navigatorKey: ContextHolder.key, home: const OobachtApp()));

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
  Position? position = await getCurrentPosition();
  if (position != null) {
    sendPositionToFirebase(position.latitude, position.longitude);
  }
}

void sendPositionToFirebase(double latitude, double longitude) async {
  UserFunctions.updateLocation(LatLng(latitude, longitude));
}

class OobachtApp extends StatefulWidget {
  const OobachtApp({super.key});

  @override
  State<OobachtApp> createState() => _OobachtAppState();
}

class _OobachtAppState extends State<OobachtApp> {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

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
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    precacheImage(const AssetImage("assets/logo.png"), context);
    return MaterialApp(
      title: 'OObacht!',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      home: LocationPermissionWrapper(),
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
      if(prefs.getBool('pushNotifications') != null){
        //standard is true
        if(prefs.getBool('pushNotifications') == false) globals.pushNotificationsActivated = false;
      }
    });
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // <-- Event handler
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
