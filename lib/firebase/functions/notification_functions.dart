import 'package:cloud_functions/cloud_functions.dart';
import 'package:oobacht/firebase/url_helper.dart';

class NotificationFunctions {
  static Future<void> updateFcmToken(String fcmToken) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("updateFcmToken"),
    );

    final response = await callable.call(<String, dynamic>{
      'fcmToken': fcmToken,
    });
  }
}