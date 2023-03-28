import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../logic/classes/report.dart';
import '../../../utils/map_utils.dart';
import '../../main_menu/pages/main_map/components/customgooglemap.dart';
import '../../main_menu/pages/main_map/components/mapcaption.dart';

class MapSection extends StatefulWidget {
  final Report reportData;
  const MapSection({Key? key, required this.reportData}) : super(key: key);

  @override
  _MapSectionState createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  late GoogleMapController mapController;
  Widget _showedWidget = const Center(child: CircularProgressIndicator());
  bool mapCreated = false;
  late HashMap<String, Marker> _markers = HashMap();

  @override
  Widget build(BuildContext context) {
    if (!mapCreated) _createMap();
    return _showedWidget;
  }

  Future<void> _createMap() async {
    final theme = Theme.of(context);

    List<Report> reports = [widget.reportData];
    Position? currentPosition;

    _markers = await generateMarkers(reports, theme, context);

    currentPosition = await getCurrentPosition(context);
    setState(() {
      mapCreated = true;
      _showedWidget = Stack(
        children: [
          CustomGoogleMap(currentPosition: currentPosition, markers: _markers),
          MapCaption(reportsList: reports)
        ],
      );
    });
  }
}
