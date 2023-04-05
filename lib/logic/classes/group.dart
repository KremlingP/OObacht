import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oobacht/utils/json_serialization/color_converter.dart';
import 'package:oobacht/utils/json_serialization/icon_converter.dart';

@JsonSerializable()
class Group {
  final String id;
  final String name;
  @IconConverter()
  final IconData icon;
  @ColorConverter()
  final Color color;

  Group(this.id, this.name, this.icon, this.color);
}
