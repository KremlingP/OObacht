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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentPosition = getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    print('\n KARTE BAUT');
    final theme = Theme.of(context);
    return FutureBuilder(
      future: markers,
      builder: (context, AsyncSnapshot<dynamic> markerSnapshot) {
        print('BUILDER läuft \n ${markerSnapshot.data} \n');
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
                              reports: widget.reports,
                              showMarkerDetails: widget.showMarkerDetails,
                              currentPosition: locationSnapshot.data,
                              markers: markerSnapshot.data),
                          MapCaption(reportsList: widget.reports),
                        ],
                      )
                    : CustomGoogleMap(
                        reports: widget.reports,
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
