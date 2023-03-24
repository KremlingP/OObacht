import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/main_menu/pages/main_map/services/marker_icon_generator.dart';

import '../../../report_details/report_details_screen.dart';
import '../../../../utils/navigator_helper.dart' as navigator;

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final List<Report> _reportsMOCK = [
    Report(
        "0",
        "Test 0",
        "Desc 0",
        DateTime.now(),
        [Group("pets", "Gefahr für Tiere", Icons.pets, Colors.brown)],
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
          Group("general", "Allgemeine Gefahr", Icons.dangerous_rounded,
              Colors.red)
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

  Position? _currentPosition;
  late GoogleMapController mapController;
  Widget _widget = const Center(child: CircularProgressIndicator());
  bool mapCreated = false;

  Future<void> _createMap() async {
    final theme = Theme.of(context);
    List<Report> reportsList = _reportsMOCK;
    _checkMultipleCategories(reportsList);
    MarkerGenerator markerGenerator = MarkerGenerator(100);

    _markers.clear();
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
      _markers[report.id] = marker;
    }

    await _getCurrentPosition();
    setState(() {
      _widget = Stack(
        children: [
          _createGoogleMap(),
          Positioned(
            top: 10,
            left: 10,
            height: 105,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                headingRowHeight: 0,
                dataRowHeight: 25,
                dataRowColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(147, 150, 153, 0.5)),
                columnSpacing: 1,
                border: TableBorder.all(
                  color: Colors.transparent,
                ),
                columns: const [
                  DataColumn(
                      label: Text('Icon')
                  ),
                  DataColumn(
                      label: Text('NAME')
                  ),
                ],
                rows: reportsList.map((e) =>
                  DataRow(
                    cells: [
                      DataCell(
                        Icon(e.groups[0].icon, color: e.groups[0].color),
                      ),
                      DataCell(
                        Text(e.groups[0].name),
                      ),
                    ],
                  ),
                ).toList(),
              ),
            ),
          ),
        ],
      );
    });
  }

  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    if (!mapCreated) _createMap();
    return _widget;
  }

  GoogleMap _createGoogleMap() {
    mapCreated = true;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng((_currentPosition?.latitude ?? 48.445166),
            (_currentPosition?.longitude ?? 8.696739)),
        zoom: 14.0,
      ),
      markers: _markers.values.toSet(),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      myLocationEnabled: true,
      compassEnabled: true,
    );
  }

  Future<bool> _handleLocationPermission() async {
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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e.toString());
    });
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
}
