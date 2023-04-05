import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO Check if ColorConverter works correct

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  fromJson(int hexColorValue) => Color(hexColorValue);

  @override
  int toJson(Color color) {
    final colorString = color.toString();
    return int.parse(colorString);
  }
}
