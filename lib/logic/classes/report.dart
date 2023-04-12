import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/utils/json_serialization/date_time_converter.dart';
import 'package:oobacht/utils/json_serialization/location_converter.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  final String? id;
  final String title;
  final String description;
  @DateTimeConverter()
  final DateTime? creationDate;
  final List<Group> groups;
  @LocationConverter()
  final LatLng location;
  final String imageUrl;

  Report(this.id, this.title, this.description, this.creationDate, this.groups,
      this.location, this.imageUrl);

  /// Connect the generated [_$ReportFromJson] function to the `fromJson`
  /// factory.
  factory Report.fromJson(Map<dynamic, dynamic> json) => _$ReportFromJson(json);

  /// Connect the generated [_$ReportToJson] function to the `toJson` method.
  Map<dynamic, dynamic> toJson() => _$ReportToJson(this);
}
