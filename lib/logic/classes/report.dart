import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/repeating_reports_enum.dart';

class Report {
  final String? id;
  final String title;
  final String description;
  final DateTime? creationDate;
  final List<Group> groups;
  final LatLng location;
  final String imageUrl;
  final List<String> alternatives;
  final List<RepeatingReportsEnum> repeatingReport;

  Report(this.id, this.title, this.description, this.creationDate, this.groups,
      this.location, this.imageUrl, this.alternatives, this.repeatingReport);
}
