import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/firebase/functions/report_functions.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/repeating_reports_enum.dart';
import 'package:oobacht/screens/main_menu/main_menu_screen.dart';
import 'package:oobacht/screens/new_report/components/alternativepicker.dart';
import 'package:oobacht/screens/new_report/components/descriptioninputfield.dart';
import 'package:oobacht/screens/new_report/components/photopicker.dart';
import 'package:oobacht/screens/new_report/components/titleinputfield.dart';
import 'package:oobacht/utils/map_utils.dart';
import 'package:oobacht/utils/navigator_helper.dart';
import 'package:oobacht/widgets/categorypicker.dart';
import 'package:oobacht/widgets/error_text.dart';
import 'package:oobacht/widgets/map/map_widget.dart';

import '../../logic/classes/report.dart';
import 'components/repeatingpicker.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({Key? key, required this.reports, required this.categories}) : super(key: key);

  final Future<List<Report>> reports;
  final List<Group> categories;

  @override
  _NewReportScreenState createState() => _NewReportScreenState();

  static _NewReportScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NewReportScreenState>();
}

class _NewReportScreenState extends State<NewReportScreen> {
  bool mapCreated = false;

  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  List<Object?> selectedCategories = [];
  File imageFile = File('');
  LatLng? position;
  List<String> alternatives = [];
  List<Object?> repeatingReport = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double shortestViewportWidth = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
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
                    CategoryPicker(superScreen: "newReport", categories: widget.categories, selectedCategories: const []),
                    const SizedBox(height: 20),
                    const PhotoPicker(),
                    const SizedBox(height: 20),

                    /// Alternative picker
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 3.0)),
                      child: const AlternativePicker(),
                    ),
                    const SizedBox(height: 20),
                    const RepeatingPicker(),
                    const SizedBox(height: 20),

                    ///Map
                    Container(
                      height: shortestViewportWidth * 0.66,
                      width: shortestViewportWidth * 0.66,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 3.0)),
                      child: FutureBuilder(
                        future: widget.reports,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasError) {
                            return const ErrorText(
                                text: "Fehler beim Laden der Karte!");
                          }
                          if (snapshot.hasData) {
                            return MapWidget(
                              reports: snapshot.data,
                              showMarkerDetails: false,
                              showMapCaption: false,
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Position? retrievedPosition = await getCurrentPosition();
                  if (retrievedPosition == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Aktueller Standort konnte nicht ermittelt werden. Versuche es erneut.')));
                    return;
                  }
                  position = LatLng(
                      retrievedPosition.latitude, retrievedPosition.longitude);

                  String base64Image = "";
                  if(imageFile.path != "") {
                    List<int> imageBytes = await imageFile.readAsBytes();
                    base64Image = base64Encode(imageBytes);
                  }
                  Report report = Report(
                    null,
                    title,
                    description,
                    null,
                    selectedCategories.map((e) => e as Group).toList(),
                    position!,
                    base64Image,
                    alternatives,
                    repeatingReport
                        .map((e) => e as RepeatingReportsEnum)
                        .toList(),
                  );
                  ReportFunctions.createReport(report);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Meldung wurde gespeichert!')));
                  navigateToNewScreen(
                      newScreen: const MainMenuScreen(), context: context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Bitte alle Felder ausfüllen.')));
                }
              },
              label: const Text('Meldung erstellen'),
              icon: const Icon(Icons.save),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.primaryColor),
        ),
      ),
    );
  }
}
