import 'package:context_holder/context_holder.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:oobacht/firebase/functions/notification_functions.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

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
      RemoteNotification? notification = message.notification;
      String title = notification?.title ?? '';
      String body = notification?.body ?? '';
      showNotificationWhileAppRunning(title, body);
    });
  }

  Future<void> sendFcmTokenToServer(String fcmToken) async {
    NotificationFunctions.updateFcmToken(fcmToken);
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