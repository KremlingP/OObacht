// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<dynamic, dynamic> json) => Report(
      json['id'] as String?,
      json['title'] as String,
      json['description'] as String,
      _$JsonConverterFromJson<Map<dynamic, dynamic>, DateTime>(
          json['creationDate'], const DateTimeConverter().fromJson),
      (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<dynamic, dynamic>))
          .toList(),
      const LocationConverter().fromJson(json['location'] as Map),
      json['imageUrl'] as String,
      json['alternatives'] != null ?
          (json['alternatives'] as List<dynamic>).map((e) => e as String).toList()
          : [],
      json['repeatingReport'] != null ?
          (json['repeatingReport'] as List<dynamic>)
              .map((e) => $enumDecode(_$RepeatingReportsEnumEnumMap, e))
              .toList()
          : [],
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'creationDate': _$JsonConverterToJson<Map<dynamic, dynamic>, DateTime>(
          instance.creationDate, const DateTimeConverter().toJson),
      'groups': instance.groups,
      'location': const LocationConverter().toJson(instance.location),
      'image': instance.image,
      'alternatives': instance.alternatives,
      'repeatingReport': instance.repeatingReport
          .map((e) => _$RepeatingReportsEnumEnumMap[e]!)
          .toList(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$RepeatingReportsEnumEnumMap = {
  RepeatingReportsEnum.rain: 'rain',
  RepeatingReportsEnum.wind: 'wind',
  RepeatingReportsEnum.hot: 'hot',
  RepeatingReportsEnum.frost: 'frost',
  RepeatingReportsEnum.snow: 'snow',
  RepeatingReportsEnum.thunder: 'thunder',
  RepeatingReportsEnum.hail: 'hail',
  RepeatingReportsEnum.fog: 'fog',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
