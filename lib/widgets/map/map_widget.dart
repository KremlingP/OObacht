import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: generateMarkers(
          widget.reports, theme, context, widget.showMarkerDetails),
      builder: (context, markerSnapshot) {
        if (markerSnapshot.hasError) {
          return const ErrorText(text: "Fehler beim Laden der Karte!");
        }
        if (markerSnapshot.hasData) {
          return FutureBuilder(
            future: getCurrentPosition(context),
            builder: (context, locationSnapshot) {
              if (locationSnapshot.hasError) {
                return const ErrorText(
                    text: "Fehler beim Auslesen des aktuellen Standortes!");
              }
              if (locationSnapshot.hasData) {
                return widget.showMapCaption
                    ? Stack(
                        children: [
                          CustomGoogleMap(
                              currentPosition: locationSnapshot.data!,
                              markers: markerSnapshot.data!),
                          MapCaption(reportsList: widget.reports),
                        ],
                      )
                    : CustomGoogleMap(
                        currentPosition: locationSnapshot.data!,
                        markers: markerSnapshot.data!);
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
