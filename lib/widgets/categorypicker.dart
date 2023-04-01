import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:oobacht/screens/main_menu/drawer/pages/profile.dart';

import '../logic/classes/group.dart';
import '../screens/new_report/new_report_screen.dart';

class CategoryPicker extends StatefulWidget {
  final String superScreen;

  const CategoryPicker({Key? key, required this.superScreen}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryPickerState();
}

// TODO get categories from backend
final List<Group> categoriesMOCK = [
  Group("general", "Allgemeine Gefahr", Icons.dangerous_rounded, Colors.red),
  Group("childs", "Gefahr für Kinder", Icons.child_friendly, Colors.yellow),
  Group("pets", "Gefahr für Tiere", Icons.pets, Colors.brown),
  Group("traffic", "Gefahr für Verkehr", Icons.directions_car, Colors.green),
  Group("climber", "Gefahr für Kletterer", Icons.sports, Colors.blue),
  Group("other", "Sonstige Gefahr", Icons.warning, Colors.orange),
];

class _CategoryPickerState extends State<CategoryPicker> {
  List<Group> categories = categoriesMOCK;
  List<Object?> selectedCategories = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryItems =
        categories.map((e) => MultiSelectItem<Group>(e, e.name)).toList();
    return MultiSelectBottomSheetField(
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
      confirmText:
          Text("Auswählen", style: TextStyle(color: theme.primaryColor)),
      cancelText:
          Text("Abbrechen", style: TextStyle(color: theme.primaryColor)),
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
          if (widget.superScreen == "newReport") {
            NewReportScreen.of(context)?.selectedCategories =
                selectedCategories;
          } else if (widget.superScreen == "profile") {
            ProfileDrawerPage.of(context)?.selectedCategories =
                selectedCategories;
          } else {
            throw Exception("Unknown superScreen: ${widget.superScreen}");
          }
        });
        _multiSelectKey.currentState?.validate();
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            selectedCategories.remove(value);
            NewReportScreen.of(context)?.selectedCategories =
                selectedCategories;
          });
          _multiSelectKey.currentState?.validate();
        },
      ),
    );
  }
}
