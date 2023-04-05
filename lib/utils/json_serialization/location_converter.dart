import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO implement LocationConverter

class LocationConverter implements JsonConverter<LatLng, Map<double, double>> {
  const LocationConverter();

  @override
  fromJson(Map<double, double> map) =>
      LatLng(map.values.elementAt(0), map.values.elementAt(1));

  @override
  Map<double, double> toJson(LatLng latLng) {
    return new Map();
  }
}
