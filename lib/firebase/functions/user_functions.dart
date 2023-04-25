import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/firebase/url_helper.dart';

import '../../utils/json_serialization/location_converter.dart';

class UserFunctions {
  static Future<void> updateFcmToken(String fcmToken) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("updateFcmToken"),
    );

    final response = await callable.call(<String, dynamic>{
      'fcmToken': fcmToken,
    });
  }

  static Future<void> updateLocation(LatLng latLng) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("updateLocation"),
    );

    final response = await callable.call(<String, dynamic>{
      'location': const LocationConverter().toJson(latLng),
    });
  }

  static Future<int> getRadius() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("getRadius"),
    );

    final response = await callable.call();
    if(response.data == null) {
      return -1;
    }
    return response.data["radius"];
  }

  static Future<void> updateRadius(int radius) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("updateRadius"),
    );

    final response = await callable.call(<String, dynamic>{
      'radius': radius,
    });
  }

  static Future<void> deleteUser() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("deleteUser"),
    );

    final response = await callable.call();
  }
}