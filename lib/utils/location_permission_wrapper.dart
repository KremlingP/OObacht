import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oobacht/utils/auth_wrapper.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/error_text.dart';

class LocationPermissionWrapper extends StatefulWidget {
  const LocationPermissionWrapper({Key? key}) : super(key: key);

  @override
  _LocationPermissionWrapperState createState() =>
      _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper>
    with WidgetsBindingObserver {
  bool locationPermissionGranted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    MediaQueryData data = MediaQuery.of(context);

    return FutureBuilder(
      future: initialRequestPermission(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              backgroundColor: theme.colorScheme.background,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 100,
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: ErrorText(
                        text:
                            "Fehler beim Auslesen der Standort-Berechtigungen, bitte aktiviere diese in den Optionen oder starte ggf. die App neu!"),
                  ),
                ],
              ));
        }
        if (!locationPermissionGranted) {
          return Scaffold(
            backgroundColor: Colors.orange,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: data.size.shortestSide / 5,
                  width: data.size.shortestSide / 1.4,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "OObacht! benötigt immer Berechtigungen auf deinen Standort, um dir relevante Meldungen zu senden, bitte aktiviere diese in den Einstellungen!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.background,
                      foregroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await requestPermission();
                    },
                    child: const Text('Berechtigungen erteilen'))
              ],
            ),
          );
        }
        return const AuthWrapper();
      },
    );
  }

  Future<void> initialRequestPermission() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      result = await Permission.locationAlways.request();
    } else {
      result = await Permission.locationWhenInUse.request();
      if (result.isGranted) {
        result = await Permission.locationAlways.request();
      }
    }

    if (result.isGranted) {
      locationPermissionGranted = true;
    }
  }

  Future<void> requestPermission() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      result = await Permission.locationAlways.request();
    } else {
      result = await Permission.locationWhenInUse.request();
      if (result.isGranted) {
        result = await Permission.locationAlways.request();
      }
    }

    if (result.isGranted) {
      setState(() {
        locationPermissionGranted = true;
      });
    } else {
      await openAppSettings();
      initialRequestPermission();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If user resumed to this app, check permission
    if (state == AppLifecycleState.resumed) {
      requestPermission();
    }
  }
}
