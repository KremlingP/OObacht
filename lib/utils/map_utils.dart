import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../logic/classes/group.dart';
import '../logic/classes/report.dart';
import '../screens/report_details/report_details_screen.dart';
import 'marker_icon_generator.dart';
import '../../../../utils/navigator_helper.dart' as navigator;

Future<HashMap<String, Marker>> generateMarkers(List<Report> reportsList, ThemeData theme, BuildContext context) async {
  _checkMultipleCategories(reportsList);
  MarkerGenerator markerGenerator = MarkerGenerator(100);
  final HashMap<String, Marker> markers = HashMap();
  for (final report in reportsList) {
    var icon = await markerGenerator.createBitmapDescriptorFromIconData(
        report.groups[0].icon,
        theme.primaryColor,
        report.groups[0].color,
        theme.colorScheme.background);
    final marker = Marker(
      markerId: MarkerId(report.id),
      position: report.location,
      icon: icon,
      infoWindow: InfoWindow(
        title: report.title,
        snippet: report.description,
        onTap: () {
          navigator.navigateToNewScreen(
              newScreen: const ReportDetailsScreen(), context: context);
        },
      ),
    );
    markers[report.id] = marker;
  }
  return markers;
}

void _checkMultipleCategories(List<Report> reportsList) {
  for (final report in reportsList) {
    if (report.groups.length > 1) {
      report.groups.insert(0,
          Group(
            "multiple",
            "Mehrere Kategorien",
            Icons.category,
            Colors.grey,
          )
      );
    }
  }
}

Future<Position?> getCurrentPosition(BuildContext context) async {
  Position? currentPosition;
  final hasPermission = await _handleLocationPermission(context);
  if (!hasPermission) return null;
  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
    currentPosition = position;
  }).catchError((e) {
    debugPrint(e.toString());
  });
  return currentPosition;
}

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Der Standort ist deaktiviert. Bitte aktiviere ihn in den Einstellungen.')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Standortzugriff verweigert. Bitte erlaube den Zugriff in den Einstellungen.')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Standortzugriff permanent verweigert. Bitte erlaube den Zugriff in den Einstellungen.')));
    return false;
  }
  return true;
}