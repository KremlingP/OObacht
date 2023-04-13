import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/widgets/error_text.dart';
import 'package:oobacht/widgets/loading_hint.dart';

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
  late Future<Position?> currentPosition;
  late Future<HashMap<String, Marker>> markers;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    markers =
        generateMarkers(widget.reports, context, widget.showMarkerDetails);
    currentPosition = getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      initialData: markers,
      future:
          generateMarkers(widget.reports, context, widget.showMarkerDetails),
      builder: (context, AsyncSnapshot<dynamic> markerSnapshot) {
        if (markerSnapshot.hasError) {
          return const ErrorText(text: "Fehler beim Laden der Karte!");
        }
        if (markerSnapshot.hasData) {
          return FutureBuilder(
            future: currentPosition,
            builder: (context, AsyncSnapshot<dynamic> locationSnapshot) {
              if (locationSnapshot.hasError) {
                return const ErrorText(
                    text: "Fehler beim Auslesen des aktuellen Standortes!");
              }
              if (locationSnapshot.hasData) {
                return widget.showMapCaption
                    ? Stack(
                        children: [
                          CustomGoogleMap(
                              showMarkerDetails: widget.showMarkerDetails,
                              currentPosition: locationSnapshot.data,
                              markers: markerSnapshot.data),
                          MapCaption(reportsList: widget.reports),
                        ],
                      )
                    : CustomGoogleMap(
                        showMarkerDetails: widget.showMarkerDetails,
                        currentPosition: locationSnapshot.data,
                        markers: markerSnapshot.data);
              } else {
                return const LoadingHint(
                    text: "Bestimme aktuellen Standort...");
              }
            },
          );
        } else {
          return const LoadingHint(text: "Lade Karte...");
        }
      },
    );
  }
}
