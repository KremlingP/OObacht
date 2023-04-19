import 'package:cloud_functions/cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/firebase/url_helper.dart';
import 'package:oobacht/logic/classes/group.dart';

import '../../utils/json_serialization/location_converter.dart';

class GroupFunctions {
  static Future<void> _subscribeGroup(Group group) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("subscribeGroup"),
    );

    final response = await callable.call(<String, dynamic>{
      'group': group.id,
    });
  }

  static Future<void> _unsubscribeGroup(Group group) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("unsubscribeGroup"),
    );

    final response = await callable.call(<String, dynamic>{
      'group': group.id,
    });
  }

  static Future<List<Group>> getOwnGroups() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("getOwnGroups"),
    );

    final response = await callable.call();
    if (response.data == null) {
      return [];
    }
    return List<Group>.from(response.data.map((e) => Group.fromJson(e)));
  }

  static Future<List<Group>> getAllGroups() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("getAllGroups"),
    );

    final response = await callable.call();
    if (response.data == null) {
      return [];
    }
    return response.data.map((e) => Group.fromJson(e)).toList();
  }

  static Future<void> updateGroupPreferences(List<Group> selectedGroups) async {
    List<Group> subscribedGroups = await getOwnGroups();
    List<Group> unsubscribedGroups = subscribedGroups
        .where((group) => !selectedGroups.contains(group))
        .toList();
    List<Group> subscribedNewGroups = selectedGroups
        .where((group) => !subscribedGroups.contains(group))
        .toList();
    for (var group in unsubscribedGroups) {
      await _unsubscribeGroup(group);
    }
    for (var group in subscribedNewGroups) {
      await _subscribeGroup(group);
    }
  }
}
