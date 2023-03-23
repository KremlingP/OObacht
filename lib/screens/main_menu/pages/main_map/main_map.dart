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
    Report("0", "Test 0", "Desc 0", DateTime.now(), [Group("pets", "Gefahr für Tiere", Icons.pets, Colors.brown)], const LatLng(48.445166, 8.696739), ""),
    Report("1", "Test 1", "Desc 1", DateTime.now(), [Group("childs", "Gefahr für Kinder", Icons.child_friendly, Colors.yellow)], const LatLng(48.445166, 8.686739), ""),
    Report("2", "Test 2", "Desc 2", DateTime.now(), [Group("general", "Allgemeine Gefahr", Icons.dangerous_rounded, Colors.red)], const LatLng(48.445166, 8.676739), ""),
    Report("3", "Test 3", "Desc 3", DateTime.now(), [Group("climber", "Gefahr für Kletterer", Icons.sports, Colors.blue)], const LatLng(48.445166, 8.666739), ""),
  ];

  Position? _currentPosition;
  late GoogleMapController mapController;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final theme = Theme.of(context);

    List<Report> reportsList = _reportsMOCK;

    _getCurrentPosition;

    MarkerGenerator markerGenerator = MarkerGenerator(100);
    _markers.clear();
    for (final report in reportsList) {
      var icon = await markerGenerator.createBitmapDescriptorFromIconData(
          report.groups[0].icon, theme.primaryColor, report.groups[0].color, theme.colorScheme.background);

      setState(() {
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
      });
    }
  }

  IconData testMethod(Report report) {
    return report.groups[0].icon;
  }

  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double lat = _currentPosition?.longitude ?? 48.445166;
    double long = _currentPosition?.longitude ?? 18.696739;
    final LatLng center = LatLng(lat, long);
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 14.0,
      ),
      markers: _markers.values.toSet(),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer(),),
      },
    );
  }

  Future<bool> _handleLocationPermission() async {
    print(">> Entered _handleLocationPermission");
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print(">> ${_currentPosition?.latitude} ${_currentPosition?.longitude}");
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
