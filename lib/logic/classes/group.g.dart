// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<dynamic, dynamic> json) => Group(
      json['id'] as String,
      json['name'] as String,
      const IconConverter().fromJson(json['iconPath'] as String?),
      const ColorConverter().fromJson(json['color'] as String),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': const IconConverter().toJson(instance.icon),
      'color': const ColorConverter().toJson(instance.color),
    };
