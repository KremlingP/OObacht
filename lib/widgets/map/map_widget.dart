import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/report.dart';

import '../../utils/map_utils.dart';
import 'components/customgooglemap.dart';
import 'components/mapcaption.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {Key? key,
      required this.reports,
      required this.showMarkerDetails,
      required this.showMapCaption})
      : super(key: key);

  final List<Report> reports;
  final bool showMarkerDetails;
  final bool showMapCaption;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Position? _currentPosition;
  late GoogleMapController mapController;
  Widget _widget = const Center(child: CircularProgressIndicator());
  bool mapCreated = false;
  late HashMap<String, Marker> _markers = HashMap();

  Future<void> _createMap() async {
    final theme = Theme.of(context);

    _markers = await generateMarkers(
        widget.reports, theme, context, widget.showMarkerDetails);

    _currentPosition = await getCurrentPosition(context);
    setState(() {
      mapCreated = true;
      _widget = widget.showMapCaption
          ? Stack(
              children: [
                CustomGoogleMap(
                    currentPosition: _currentPosition, markers: _markers),
                MapCaption(reportsList: widget.reports),
              ],
            )
          : CustomGoogleMap(
              currentPosition: _currentPosition, markers: _markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mapCreated) _createMap();
    return _widget;
  }
}
