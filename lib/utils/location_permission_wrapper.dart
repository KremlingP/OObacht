import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:oobacht/utils/auth_wrapper.dart';
import 'package:oobacht/widgets/ErrorTextWithIcon.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionWrapper extends StatefulWidget {
  const LocationPermissionWrapper({Key? key}) : super(key: key);

  @override
  _LocationPermissionWrapperState createState() =>
      _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper>
    with WidgetsBindingObserver {
  bool locationPermissionGranted = false;
  late Future<void> initialMethod;

  @override
  void initState() {
    super.initState();
    initialMethod = initialRequestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    MediaQueryData data = MediaQuery.of(context);

    return FutureBuilder(
      future: initialMethod,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              backgroundColor: theme.colorScheme.background,
              body: const ErrorTextWithIcon(
                icon: Icons.info_outline,
                text:
                    "Fehler beim Auslesen der Standort-Berechtigungen, bitte aktiviere diese in den Optionen oder starte ggf. die App neu!",
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
                    "OObacht! benötigt immer Berechtigungen auf deinen Standort, um dir relevante Meldungen in deiner Umgebung zu senden, bitte aktiviere diesen in den Einstellungen!",
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
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      }
      result = await Permission.locationWhenInUse.request();
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
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      }
      result = PermissionStatus.granted;
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
