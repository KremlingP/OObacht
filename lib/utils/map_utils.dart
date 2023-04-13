import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';
import 'package:oobacht/utils/navigator_helper.dart' as navigator;

import '../logic/classes/report.dart';
import 'marker_icon_generator.dart';

Future<HashMap<String, Marker>> generateMarkers(List<Report> reportsList,
    BuildContext context, bool showMarkerDetails) async {
  final theme = Theme.of(context);
  MarkerGenerator markerGenerator = MarkerGenerator(100);
  final HashMap<String, Marker> markers = HashMap();
  for (final report in reportsList) {
    BitmapDescriptor icon;
    if (report.groups.length > 1) {
      icon = await markerGenerator.createBitmapDescriptorFromIconData(
          Icons.category,
          theme.primaryColor,
          Colors.grey,
          theme.colorScheme.background);
    } else {
      icon = await markerGenerator.createBitmapDescriptorFromIconData(
          report.groups[0].icon,
          theme.primaryColor,
          report.groups[0].color,
          theme.colorScheme.background);
    }
    final marker = Marker(
      markerId: MarkerId(report.id ?? ""),
      position: report.location,
      icon: icon,
      infoWindow: showMarkerDetails
          ? InfoWindow(
              title: report.title,
              snippet: report.description,
              onTap: () {
                navigator.navigateToNewScreen(
                    newScreen: ReportDetailsScreen(
                      reportData: report,
                    ),
                    context: context);
              },
            )
          : const InfoWindow(),
    );
    markers[report.id ?? ""] = marker;
  }
  return markers;
}

Future<Position?> getCurrentPosition() async {
  Position? currentPosition;

  bool serviceEnabled;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    currentPosition = position;
  }).catchError((e) {
    debugPrint(e.toString());
  });
  return currentPosition;
}
