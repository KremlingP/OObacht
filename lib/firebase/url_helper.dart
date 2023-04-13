import 'package:cloud_functions/cloud_functions.dart';

class UrlHelper {
  static String baseUrl =
      'https://europe-west1-oobacht-ea4d4.cloudfunctions.net';

  static String getFunctionUrl(String functionName) {
    return '$baseUrl/$functionName';
  }

  static void printFirebaseFunctionsException(
      FirebaseFunctionsException error, String functionName) {
    print("FirebaseFunctionError at function $functionName!");
    print("Error Code: ${error.code}");
    print("Error Details: ${error.details}");
    print("Error Message: ${error.message}");
    print("Error StackTrace: ${error.stackTrace}");
  }
}
