import 'package:cloud_functions/cloud_functions.dart';
import 'package:oobacht/firebase/url_helper.dart';
import 'package:oobacht/logic/classes/report.dart';

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
}
