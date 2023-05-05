import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

class LocationConverter
    implements JsonConverter<LatLng, Map<dynamic, dynamic>> {
  const LocationConverter();

  @override
  LatLng fromJson(Map<dynamic, dynamic> map) =>
      LatLng((map['_latitude']*1.0) as double, (map['_longitude']*1.0) as double);

  @override
  Map<String, double> toJson(LatLng latLng) {
    return <String, double>{
      '_longitude': latLng.longitude,
      '_latitude': latLng.latitude
    };
  }
}
