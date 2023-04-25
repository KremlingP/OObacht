import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class IconConverter implements JsonConverter<NetworkImage, String> {
  const IconConverter();

  @override
  fromJson(String? iconUrl) => NetworkImage(iconUrl ?? '');

  @override
  String toJson(NetworkImage imageIcon) {
    return "";
  }
}
