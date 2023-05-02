import 'package:context_holder/context_holder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:oobacht/firebase/functions/user_functions.dart';
import 'package:oobacht/globals.dart' as globals;

class PushNotificationService {
  final FirebaseMessaging _fcm;

  static int semaphore = 0;

  PushNotificationService(this._fcm);

  Future initialise() async {
    _fcm.requestPermission();

    String? token = await _fcm.getToken();
    if(token != null) {
      await sendFcmTokenToServer(token);
    }

    _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      await sendFcmTokenToServer(fcmToken);
    }).onError((err) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // This workaround is needed because of a FirebaseMessaging bug
      // where messages are received twice or more often
      if (semaphore != 0) {
        return;
      }
      semaphore = 1;
      Future.delayed(const Duration(seconds: 1)).then((_) => semaphore = 0);
      handleMessage(message);
    });
  }

  void handleMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    String title = notification?.title ?? '';
    String body = notification?.body ?? '';
    showNotificationWhileAppRunning(title, body);
  }

  Future<void> sendFcmTokenToServer(String fcmToken) async {
    if(globals.pushNotificationsActivated) {
      UserFunctions.updateFcmToken(fcmToken);
    } else {
      UserFunctions.updateFcmToken("");
    }
  }

  Future<void> showNotificationWhileAppRunning(String title, String description) async {
    return showDialog<void>(
      context: ContextHolder.currentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Neue Benachrichtigung: $title'),
          content: SingleChildScrollView(
            child: Text(description),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Gelesen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}