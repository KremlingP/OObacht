import 'dart:async';
import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/utils/theme.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({Key? key,required this.currentPosition,
    required this.markers,}) : super(key: key);

  final Position? currentPosition;
  final HashMap<String, Marker> markers;

  @override
  _CustomGoogleMapState createState() => _CustomGoogleMapState();

  static _CustomGoogleMapState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomGoogleMapState>();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> with WidgetsBindingObserver {
  late String _darkMapStyle;
  late String _lightMapStyle;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _setMapStyleByCustomTheme(theme);
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng((widget.currentPosition?.latitude ?? 48.445166),
            (widget.currentPosition?.longitude ?? 8.696739)),
        zoom: 14.0,
      ),
      markers: widget.markers.values.toSet(),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      myLocationEnabled: true,
      compassEnabled: true,
    );
  }

  Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle = await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyleByCustomTheme(ThemeData theme) async {
    final controller = await _controller.future;
    if (theme.primaryColor == Colors.white) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      controller.setMapStyle(_lightMapStyle);
    }
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      controller.setMapStyle(_lightMapStyle);
    }
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
