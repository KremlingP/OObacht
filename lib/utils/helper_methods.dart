class HelperMethods {
  static String getDisplayDate(DateTime dateTime) {
    return '${dateTime.day < 10 ? '0' : ''}${dateTime.day}.${dateTime.month < 10 ? '0' : ''}${dateTime.month}.${dateTime.year}';
  }
}
