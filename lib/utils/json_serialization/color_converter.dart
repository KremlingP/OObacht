import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO Check if ColorConverter works correct

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  fromJson(String hexColorString) => Color(int.parse('0xFF$hexColorString'));

  @override
  String toJson(Color color) {
    return color.toString();
  }
}
