import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter
    implements JsonConverter<DateTime, Map<dynamic, dynamic>> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Map<dynamic, dynamic> map) =>
      DateTime.fromMillisecondsSinceEpoch(
          (map.values.elementAt(1) as int) * 1000);

  @override
  Map<String, int> toJson(DateTime dateTime) {
    return <String, int>{
      '_nanoseconds': dateTime.minute,
      '_seconds': dateTime.second
    };
  }
}
