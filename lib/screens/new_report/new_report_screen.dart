import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/screens/main_menu/main_menu_screen.dart';
import 'package:oobacht/screens/main_menu/pages/main_map/main_map.dart';
import 'package:oobacht/widgets/categorypicker.dart';
import 'package:oobacht/screens/new_report/components/descriptioninputfield.dart';
import 'package:oobacht/screens/new_report/components/photopicker.dart';
import 'package:oobacht/screens/new_report/components/titleinputfield.dart';
import 'package:oobacht/utils/map_utils.dart';
import 'package:oobacht/utils/navigator_helper.dart';

import '../../logic/classes/report.dart';
import '../main_menu/pages/main_map/components/customgooglemap.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({Key? key}) : super(key: key);

  @override
  _NewReportScreenState createState() => _NewReportScreenState();

  static _NewReportScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NewReportScreenState>();
}

// TODO get reports from backend
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


class _NewReportScreenState extends State<NewReportScreen> {
  List<Report> reportsList = _reportsMOCK;

  bool mapCreated = false;
  Widget _mapWidget = const Center(child: CircularProgressIndicator());

  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  List<Object?> selectedCategories = [];
  File imageFile = File('');
  LatLng? position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!mapCreated) _createMap();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const AutoSizeText(
          "Neue Meldung",
          style: TextStyle(fontFamily: 'Fredoka', color: Colors.white),
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.colorScheme.background,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const TitleInputField(),
                    const SizedBox(height: 20),
                    const DescriptionInputField(),
                    const SizedBox(height: 20),
                    const CategoryPicker(superScreen: "newReport"),
                    const SizedBox(height: 20),
                    const PhotoPicker(),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: 100,
                        child: _mapWidget
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended (
              onPressed: () {
                if (_formKey.currentState!.validate() && position != null) {
                  _formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meldung wurde gespeichert!')));
                  Report report = Report(
                      null,
                      title,
                      description,
                      null,
                      selectedCategories.map((e) => e as Group).toList(),
                      position!,
                      imageFile.path
                  );
                  // TODO: Save report to database
                  navigateToNewScreen(newScreen: const MainMenuScreen(), context: context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bitte alle Felder ausfüllen.')));
                }
              },
              label: const Text('Meldung erstellen'),
              icon: const Icon(Icons.save),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.primaryColor
          ),
        ),
      ),
    );
  }

  Future<void> _createMap() async {
    final theme = Theme.of(context);
    var markers = await generateMarkers(reportsList, theme, context);
    var currentPosition = await getCurrentPosition(context);

    setState(() {
      mapCreated = true;
      _mapWidget = CustomGoogleMap(
              currentPosition: currentPosition,
              markers: markers
      );
    });
    position = LatLng(currentPosition!.latitude, currentPosition.longitude);
  }

}
