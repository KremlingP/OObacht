import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;

  Group(this.id, this.name);
}
