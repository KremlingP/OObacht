import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class IconConverter implements JsonConverter<ImageProvider, String> {
  const IconConverter();

  @override
  fromJson(String? iconUrl) {
    if(iconUrl == null || iconUrl.isEmpty) {
      return const AssetImage('assets/default_group_icon.png');
    }
    return NetworkImage(iconUrl ?? '');
  }

  @override
  String toJson(ImageProvider imageIcon) {
    return "";
  }
}
