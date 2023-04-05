import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO check if LocationConverter works correct

class LocationConverter implements JsonConverter<LatLng, Map<String, double>> {
  const LocationConverter();

  @override
  fromJson(Map<String, double> map) =>
      LatLng(map.values.elementAt(0), map.values.elementAt(1));

  @override
  Map<String, double> toJson(LatLng latLng) {
    return <String, double>{
      '_longitude': latLng.longitude,
      '_latitude': latLng.latitude
    };
  }
}
