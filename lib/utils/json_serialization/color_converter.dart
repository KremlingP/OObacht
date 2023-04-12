import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO Check if ColorConverter works correct

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  fromJson(String hexColorValue) => const Color(0xFFFFFFFF);

  @override
  String toJson(Color color) {
    final colorString = color.toString();
    return int.parse(colorString).toString();
  }
}
