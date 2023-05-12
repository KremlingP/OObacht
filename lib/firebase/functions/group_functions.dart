import 'package:cloud_functions/cloud_functions.dart';
import 'package:oobacht/firebase/url_helper.dart';
import 'package:oobacht/logic/classes/group.dart';

class GroupFunctions {
  static Future<void> subscribeGroup(Group group) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("subscribeGroup"),
    );

    final response = await callable.call(<String, dynamic>{
      'groupId': group.id,
    });
  }

  static Future<void> unsubscribeGroup(Group group) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("unsubscribeGroup"),
    );

    final response = await callable.call(<String, dynamic>{
      'groupId': group.id,
    });
  }

  static Future<List<Group>> getOwnGroups() async {
    const functionName = 'getOwnGroups';

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl(functionName),
    );

    try {
      final HttpsCallableResult result = await callable.call();
      if (result.data != null) {
        final groups = result.data.map((e) => Group.fromJson(e)).toList();

        return Future.value(List<Group>.from(groups));
      }
    } on FirebaseFunctionsException catch (error) {
      UrlHelper.printFirebaseFunctionsException(error, functionName);
    }
    return [];
  }

  static Future<List<Group>> getAllGroups() async {
    const functionName = 'getAllGroups';

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl(functionName),
    );

    try {
      final HttpsCallableResult result = await callable.call();
      if (result.data != null) {
        final groups = result.data.map((e) => Group.fromJson(e)).toList();

        return Future.value(List<Group>.from(groups));
      }
    } on FirebaseFunctionsException catch (error) {
      UrlHelper.printFirebaseFunctionsException(error, functionName);
    }
    return [];
  }

  static Future<void> updateGroupPreferences(List<Group> selectedGroups) async {
    List<Group> subscribedGroups = await getOwnGroups();
    List<Group> unsubscribedGroups = [];
    List<Group> subscribedNewGroups = [];
    for (var group in subscribedGroups) {
      if (! selectedGroups.where((element) => element.id == group.id).isNotEmpty) {
        unsubscribedGroups.add(group);
      } else {
        selectedGroups.remove(selectedGroups.where((element) => element.id == group.id).first);
      }
    }
    subscribedNewGroups = selectedGroups;

    for (var group in unsubscribedGroups) {
      await unsubscribeGroup(group);
    }
    for (var group in subscribedNewGroups) {
      await subscribeGroup(group);
    }
  }
}
