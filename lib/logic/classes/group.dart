import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oobacht/utils/json_serialization/color_converter.dart';
import 'package:oobacht/utils/json_serialization/icon_converter.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;
  @JsonKey(name: 'iconPath')
  @IconConverter()
  final ImageProvider icon;
  @ColorConverter()
  final Color color;

  Group(this.id, this.name, this.icon, this.color);

  /// Connect the generated [_$GroupFromJson] function to the `fromJson`
  /// factory.
  factory Group.fromJson(Map<dynamic, dynamic> json) => _$GroupFromJson(json);

  /// Connect the generated [_$GroupToJson] function to the `toJson` method.
  Map<dynamic, dynamic> toJson() => _$GroupToJson(this);
}
