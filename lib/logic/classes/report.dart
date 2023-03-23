import 'dart:html';

import 'package:oobacht/logic/classes/group.dart';

class Report {
  final String id;
  final String title;
  final String description;
  final DateTime creationDate;
  final List<Group> groups;
  final Coordinates location;
  final String imageUrl;

  Report(this.id, this.title, this.description, this.creationDate, this.groups,
      this.location, this.imageUrl);
}
