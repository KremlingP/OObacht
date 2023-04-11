// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String?, dynamic> json) => Report(
      json['id'] as String?,
      json['title'] as String,
      json['description'] as String,
      _$JsonConverterFromJson<Map<String, int>, DateTime>(
          json['creationDate'], const DateTimeConverter().fromJson),
      (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      const LocationConverter()
          .fromJson(json['location'] as Map<String, double>),
      json['imageUrl'] as String,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'creationDate': _$JsonConverterToJson<Map<String, int>, DateTime>(
          instance.creationDate, const DateTimeConverter().toJson),
      'groups': instance.groups,
      'location': const LocationConverter().toJson(instance.location),
      'imageUrl': instance.imageUrl,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);