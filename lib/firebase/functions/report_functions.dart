import 'package:cloud_functions/cloud_functions.dart';
import 'package:oobacht/firebase/url_helper.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/utils/json_serialization/location_converter.dart';

class ReportFunctions {
  ///Test only
  static Future<void> oobacht() async {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallableFromUrl(UrlHelper.getFunctionUrl('oobacht'));

    try {
      final response = await callable.call();
      if (response.data != null) {
        print("${response.data}");
      }
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  static Future<List<Report>> getAllReports() async {
    const functionName = 'getAllReports';

    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallableFromUrl(UrlHelper.getFunctionUrl(functionName));

    try {
      final HttpsCallableResult result = await callable.call();
      if (result.data != null) {
        final reports = result.data.map((e) => Report.fromJson(e)).toList();

        return Future.value(List<Report>.from(reports));
      }
    } on FirebaseFunctionsException catch (error) {
      UrlHelper.printFirebaseFunctionsException(error, functionName);
    }
    return [];
  }

  static Future<List<Report>> getOwnReports() async {
    const functionName = 'getOwnReports';

    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallableFromUrl(UrlHelper.getFunctionUrl(functionName));

    try {
      final HttpsCallableResult result = await callable.call();
      if (result.data != null) {
        final reports = result.data.map((e) => Report.fromJson(e)).toList();

        return Future.value(List<Report>.from(reports));
      }
    } on FirebaseFunctionsException catch (error) {
      UrlHelper.printFirebaseFunctionsException(error, functionName);
    }
    return [];
  }

  static Future<bool> createReport(Report report) async {
    const functionName = 'createReport';

    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallableFromUrl(UrlHelper.getFunctionUrl(functionName));

    try {
      var map = <String, dynamic>{
        'title': report.title,
        'description': report.description,
        'groups': report.groups.map((e) => e.id).toList(),
        'location': const LocationConverter().toJson(report.location),
        'alternatives': report.alternatives,
        'repeatingReport':
            report.repeatingReport.map((e) => e.name).toList(),
      };
      if (report.image != null && report.image.isNotEmpty) {
        map.addAll(<String, dynamic>{'image': report.image});
      }

      final HttpsCallableResult result = await callable.call(map);
      if (result.data != null) {
        return result.data;
      }
    } on FirebaseFunctionsException catch (error) {
      UrlHelper.printFirebaseFunctionsException(error, functionName);
    }
    return false;
  }

  static Future<bool> deleteReport(String reportId) async {
    const functionName = 'deleteReport';

    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallableFromUrl(UrlHelper.getFunctionUrl(functionName));

    try {
      final HttpsCallableResult result =
      await callable.call(<String, String>{'id': reportId});

      return result.data;
    } on FirebaseFunctionsException catch (error) {
      UrlHelper.printFirebaseFunctionsException(error, functionName);
    }

    return false;
  }

  static Future<bool> createComplaint(String reportId) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("createComplaint"),
    );

    final response = await callable.call(<String, dynamic>{
      'reportId': reportId,
    });

    return response.data;
  }

  static Future<bool> createConcluded(String reportId) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
      UrlHelper.getFunctionUrl("createConcluded"),
    );

    final response = await callable.call(<String, dynamic>{
      'reportId': reportId,
    });

    return response.data;
  }
}
