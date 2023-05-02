import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/firebase/functions/report_functions.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/repeating_reports_enum.dart';
import 'package:oobacht/screens/new_report/components/alternativepicker.dart';
import 'package:oobacht/screens/new_report/components/descriptioninputfield.dart';
import 'package:oobacht/screens/new_report/components/input_component.dart';
import 'package:oobacht/screens/new_report/components/photopicker.dart';
import 'package:oobacht/screens/new_report/components/titleinputfield.dart';
import 'package:oobacht/utils/helper_methods.dart';
import 'package:oobacht/utils/map_utils.dart';
import 'package:oobacht/widgets/categorypicker.dart';
import 'package:oobacht/widgets/error_text.dart';
import 'package:oobacht/widgets/map/map_widget.dart';

import '../../logic/classes/report.dart';
import 'components/repeatingpicker.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen(
      {Key? key, required this.reports, required this.categories})
      : super(key: key);

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
  List<Group> selectedCategories = [];
  File imageFile = File('');
  LatLng? position;
  List<String> alternatives = [];
  List<Object?> repeatingReport = [];

  bool isCreating = false;

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
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const TitleInputField(),
                    const SizedBox(height: 10),
                    const DescriptionInputField(),
                    const SizedBox(height: 10),

                    /// Category Picker
                    InputComponent(
                      title: "Kategorien",
                      child: CategoryPicker(
                          superScreen: "newReport",
                          categories: widget.categories,
                          selectedCategories: selectedCategories),
                    ),

                    /// Photo Picker
                    const InputComponent(
                      title: "Bild",
                      child: PhotoPicker(),
                    ),

                    /// Alternative picker
                    const InputComponent(
                      title: "Alternativen",
                      child: AlternativePicker(),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    /// Repeating
                    const InputComponent(
                        title: "Wiederholung", child: RepeatingPicker()),

                    const SizedBox(
                      height: 15.0,
                    ),

                    ///Map
                    InputComponent(
                      title: "Karte",
                      child: Container(
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
                    ),
                    const SizedBox(height: 55.0),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () => isCreating ? null : _createReport(context),
              label: Text(
                  isCreating
                      ? 'Meldung wird übermittelt...'
                      : 'Meldung erstellen',
                  style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.save, color: Colors.white),
              backgroundColor: isCreating ? Colors.grey : Colors.green,
              foregroundColor: theme.primaryColor),
        ),
      ),
    );
  }

  _createReport(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (selectedCategories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Bitte wähle mindestens eine Kategorie aus.')));
        return;
      }

      Position? retrievedPosition = await getCurrentPosition();
      if (retrievedPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Aktueller Standort konnte nicht ermittelt werden. Versuche es erneut.')));
        return;
      }
      setState(() {
        isCreating = true;
      });
      position =
          LatLng(retrievedPosition.latitude, retrievedPosition.longitude);

      //TODO Verzögerung raus nehmen (für Präsi bisschen anschaulicher, wenn nicht direkt lädt)
      await Future.delayed(const Duration(seconds: 1));

      String base64Image = "";
      if (imageFile.path != "") {
        List<int> imageBytes = await imageFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
      Report report = Report(
          null,
          title,
          description,
          null,
          selectedCategories,
          position!,
          base64Image,
          alternatives,
          repeatingReport.map((e) => e as RepeatingReportsEnum).toList(),
          true,
          '');

      bool successful = await ReportFunctions.createReport(report);

      if (successful) {
        Navigator.pop(context);
      } else {
        setState(() {
          isCreating = false;
        });
      }
      showResponseSnackBar(
          context,
          successful,
          'Meldung wurde erfolgreich gespeichert!',
          'Fehler beim Erstellen der Meldung!');
    }
  }
}
