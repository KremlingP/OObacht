class UrlHelper {
  static String baseUrl =
      'https://europe-west1-oobacht-ea4d4.cloudfunctions.net';

  static String getFunctionUrl(String functionName) {
    return '$baseUrl/$functionName';
  }
}
