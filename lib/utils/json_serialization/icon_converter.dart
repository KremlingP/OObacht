import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO implement ColorConverter

class IconConverter implements JsonConverter<IconData, String> {
  const IconConverter();

  @override
  fromJson(String? iconUrl) => Icons.ten_k;

  @override
  String toJson(IconData iconData) {
    return "";
  }
}
