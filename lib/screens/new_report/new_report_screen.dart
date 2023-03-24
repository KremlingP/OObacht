import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/screens/new_report/components/photopicker.dart';
import 'package:oobacht/utils/map_utils.dart';

import '../../logic/classes/report.dart';
import '../main_menu/pages/main_map/components/customgooglemap.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({Key? key}) : super(key: key);

  @override
  _NewReportScreenState createState() => _NewReportScreenState();
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
// TODO get categories from backend
final List<Group> categoriesMOCK = [
  Group("general", "Allgemeine Gefahr", Icons.dangerous_rounded, Colors.red),
  Group("childs", "Gefahr für Kinder", Icons.child_friendly, Colors.yellow),
  Group("pets", "Gefahr für Tiere", Icons.pets, Colors.brown),
  Group("traffic", "Gefahr für Verkehr", Icons.directions_car, Colors.green),
  Group("climber", "Gefahr für Kletterer", Icons.sports, Colors.blue),
  Group("other", "Sonstige Gefahr", Icons.warning, Colors.orange),
];

class _NewReportScreenState extends State<NewReportScreen> {
  List<Report> reportsList = _reportsMOCK;
  List<Group> categories = categoriesMOCK;

  List<Object?> selectedCategories = [];

  File imageFile = File('');

  bool mapCreated = false;
  Widget _mapWidget = const Center(child: CircularProgressIndicator());

  final _formKey = GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final categoryItems = categories
        .map((e) => MultiSelectItem<Group>(e, e.name))
        .toList();

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
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 50,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: 'Titel',
                        hintText: 'Gebe den Titel der Meldung ein...',
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(color: theme.primaryColor),
                        hintStyle: TextStyle(color: theme.primaryColor.withOpacity(0.5)),
                      ),
                      style: TextStyle(color: theme.primaryColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte einen Titel eingeben.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      maxLength: 500,
                      autocorrect: true,
                      decoration: InputDecoration(
                        labelText: 'Beschreibung',
                        hintText: 'Gebe eine Beschreibung für die Meldung ein...',
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(color: theme.primaryColor),
                        hintStyle: TextStyle(color: theme.primaryColor.withOpacity(0.5)),
                      ),
                      style: TextStyle(color: theme.primaryColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte eine Beschreibung eingeben.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    MultiSelectBottomSheetField(
                      key: _multiSelectKey,
                      initialChildSize: 0.4,
                      maxChildSize: 0.95,
                      listType: MultiSelectListType.CHIP,
                      searchable: true,
                      validator: (values) {
                        if (values == null || values.isEmpty) {
                          return "Bitte mindestens eine Kategorie auswählen.";
                        }
                        return null;
                      },
                      title: Text(
                        "Kategorien",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.background,
                      selectedColor: theme.colorScheme.primary.withOpacity(0.1),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      buttonIcon: Icon(
                        Icons.category,
                        color: theme.primaryColor,
                      ),
                      buttonText: Text(
                        "Kategorien auswählen",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      confirmText: Text(
                          "Auswählen",
                          style: TextStyle(color: theme.primaryColor)
                      ),
                      cancelText: Text(
                          "Abbrechen",
                          style: TextStyle(color: theme.primaryColor)
                      ),
                      searchHint: "Suche nach Kategorien...",
                      searchHintStyle: TextStyle(
                        color: theme.primaryColor,
                      ),
                      searchIcon: Icon(
                        Icons.search,
                        color: theme.primaryColor,
                      ),
                      closeSearchIcon: Icon(
                        Icons.close,
                        color: theme.primaryColor,
                      ),
                      items: categoryItems,
                      onConfirm: (values) {
                        setState(() {
                          selectedCategories = values;
                        });
                        _multiSelectKey.currentState?.validate();
                      },
                      chipDisplay: MultiSelectChipDisplay(
                        onTap: (value) {
                          setState(() {
                            selectedCategories.remove(value);
                          });
                          _multiSelectKey.currentState?.validate();
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    const PhotoPicker(),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: 100,
                        child: _mapWidget
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("Formular ist gültig und kann verarbeitet werden");
                              // Hier können wir mit den geprüften Daten aus dem Formular etwas machen.
                            }
                          },
                          child: const Text('Speichern'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
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
  }

}
