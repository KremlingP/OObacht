import 'package:cloud_functions/cloud_functions.dart';
import 'package:oobacht/firebase/url_helper.dart';

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
}
