import 'package:json_annotation/json_annotation.dart';

//TODO implement DateTimeConverter, update Map and newDate

class DateTimeConverter implements JsonConverter<DateTime, Map<String, Map<String,int>>> {
  const DateTimeConverter();

  @override
  fromJson(Map<String, int> map) => DateTime.now();

  @override
  Map<String, int> toJson(DateTime dateTime) {
    return <String, int>{'_nanoseconds': dateTime., '_usw': dateTime.hour};
  }
}
