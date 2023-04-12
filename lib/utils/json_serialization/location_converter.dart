import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

//TODO check if LocationConverter works correct

class LocationConverter
    implements JsonConverter<LatLng, Map<dynamic, dynamic>> {
  const LocationConverter();

  @override
  LatLng fromJson(Map<dynamic, dynamic> map) => LatLng(
      map.values.elementAt(0) as double, map.values.elementAt(1) as double);

  @override
  Map<String, double> toJson(LatLng latLng) {
    return <String, double>{
      '_longitude': latLng.longitude,
      '_latitude': latLng.latitude
    };
  }
}
