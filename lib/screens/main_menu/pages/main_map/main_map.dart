import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/main_menu/pages/main_map/components/mapcaption.dart';

import '../../../../utils/map_utils.dart';
import 'components/customgooglemap.dart';

class MainMap extends StatefulWidget {
  const MainMap({Key? key, required this.reports}) : super(key: key);

  final List<Report> reports;

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  Position? _currentPosition;
  late GoogleMapController mapController;
  Widget _widget = const Center(child: CircularProgressIndicator());
  bool mapCreated = false;
  late HashMap<String, Marker> _markers = HashMap();

  Future<void> _createMap() async {
    final theme = Theme.of(context);

    _markers = await generateMarkers(widget.reports, theme, context);

    _currentPosition = await getCurrentPosition(context);
    setState(() {
      mapCreated = true;
      _widget = Stack(
        children: [
          CustomGoogleMap(
              currentPosition: _currentPosition,
              markers: _markers),
          MapCaption(reportsList: widget.reports),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mapCreated) _createMap();
    return _widget;
  }
}
