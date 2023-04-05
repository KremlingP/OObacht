import 'package:cloud_functions/cloud_functions.dart';
import 'package:oobacht/firebase/firebase_function_helper.dart';
import 'package:oobacht/logic/classes/report.dart';

class ReportFunctions {
  ///Test only
  static Future<void> oobacht() async {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallableFromUrl(FirebaseFunctionHelper.getFunctionUrl('oobacht'));

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

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallableFromUrl(
        FirebaseFunctionHelper.getFunctionUrl(functionName));

    try {
      final response = await callable.call();
      if (response.data != null) {
        print("${response.data}");
        final List<Map> resultList = response.data;

        return resultList.map((e) => Report.fromJson);
      }
    } on FirebaseFunctionsException catch (error) {
      FirebaseFunctionHelper.printFirebaseFunctionsException(
          error, functionName);
    }
    return [];
  }
}
