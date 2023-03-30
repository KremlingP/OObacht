import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget {
  final Position? currentPosition;
  final HashMap<String, Marker> markers;

  const CustomGoogleMap({
    Key? key,
    required this.currentPosition,
    required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng((currentPosition?.latitude ?? 48.445166),
            (currentPosition?.longitude ?? 8.696739)),
        zoom: 14.0,
      ),
      markers: markers.values.toSet(),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      myLocationEnabled: true,
      compassEnabled: true,
    );
  }
}
