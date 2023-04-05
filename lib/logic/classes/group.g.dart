// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['id'] as String,
      json['name'] as String,
      const IconConverter().fromJson(json['icon'] as String),
      const ColorConverter().fromJson(json['color'] as int),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': const IconConverter().toJson(instance.icon),
      'color': const ColorConverter().toJson(instance.color),
    };
