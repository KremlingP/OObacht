import 'package:cloud_functions/cloud_functions.dart';

class NotificationFunctions {
  static Future<void> updateFcmToken(String fcmToken) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      'https://europe-west1-oobacht-ea4d4.cloudfunctions.net/oobacht',
    ); // TODO Correct URL

    final response = await callable.call(<String, dynamic>{
      'fcmToken': fcmToken,
    });
  }
}