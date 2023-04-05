import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oobacht/logic/classes/group.dart';

@JsonSerializable()
class Report {
  final String? id;
  final String title;
  final String description;
  final DateTime? creationDate;
  final List<Group> groups;
  final LatLng location;
  final String imageUrl;

  Report(this.id, this.title, this.description, this.creationDate, this.groups,
      this.location, this.imageUrl);

  /// Connect the generated [_$ReportFromJson] function to the `fromJson`
  /// factory.
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
