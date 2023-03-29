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
  const MainMap({Key? key}) : super(key: key);

  @override
  _MainMapState createState() => _MainMapState();
}

// TODO get reports from backend
final List<Report> _reportsMOCK = [
  Report(
      "0",
      "Test 0",
      "Desc 0",
      DateTime.now(),
      [Group("pets", "Gefahr für Tiere", Icons.pets, Colors.brown),
        Group("general", "Allgemeine Gefahr", Icons.dangerous_rounded, Colors.red)],
      const LatLng(48.445166, 8.706739),
      ""),
  Report(
      "1",
      "Test 1",
      "Desc 1",
      DateTime.now(),
      [
        Group("childs", "Gefahr für Kinder", Icons.child_friendly, Colors.yellow),
        Group("pets", "Gefahr für Tiere", Icons.pets, Colors.brown)
      ],
      const LatLng(48.445166, 8.686739),
      ""),
  Report(
      "2",
      "Test 2",
      "Desc 2",
      DateTime.now(),
      [
        Group("general", "Allgemeine Gefahr", Icons.dangerous_rounded, Colors.red)
      ],
      const LatLng(48.445166, 8.676739),
      ""),
  Report(
      "3",
      "Test 3",
      "Desc 3",
      DateTime.now(),
      [Group("climber", "Gefahr für Kletterer", Icons.sports, Colors.blue)],
      const LatLng(48.445166, 8.666739),
      ""),
];

class _MainMapState extends State<MainMap> {
  List<Report> reportsList = _reportsMOCK;
  Position? _currentPosition;
  late GoogleMapController mapController;
  Widget _widget = const Center(child: CircularProgressIndicator());
  bool mapCreated = false;
  late HashMap<String, Marker> _markers = HashMap();

  Future<void> _createMap() async {
    final theme = Theme.of(context);

    _markers = await generateMarkers(reportsList, theme, context);

    _currentPosition = await getCurrentPosition(context);
    setState(() {
      mapCreated = true;
      _widget = Stack(
        children: [
          CustomGoogleMap(
              currentPosition: _currentPosition,
              markers: _markers),
          MapCaption(reportsList: reportsList)
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
