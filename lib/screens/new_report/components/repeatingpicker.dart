import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:oobacht/logic/classes/repeating_reports_enum.dart';

import '../new_report_screen.dart';

class RepeatingPicker extends StatefulWidget {
  const RepeatingPicker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RepeatingPickerState();
}

class _RepeatingPickerState extends State<RepeatingPicker> {
  List<Object?> selectedValues = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = RepeatingReportsEnum.values
        .map((e) => MultiSelectItem(e, getRepeatingReportName(e)))
        .toList();

    return MultiSelectBottomSheetField(
      key: _multiSelectKey,
      initialChildSize: 0.4,
      maxChildSize: 0.95,
      listType: MultiSelectListType.CHIP,
      searchable: true,
      title: Text(
        "Wiederkehrende Meldung",
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
        Icons.repeat_rounded,
        color: theme.primaryColor,
      ),
      buttonText: Text(
        "Meldung wird erneut ausgelöst:",
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: 16,
        ),
      ),
      confirmText:
          Text("Auswählen", style: TextStyle(color: theme.primaryColor)),
      cancelText:
          Text("Abbrechen", style: TextStyle(color: theme.primaryColor)),
      searchHint: "Suche nach Optionen...",
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
      items: items,
      onConfirm: (values) {
        setState(() {
          selectedValues = values;
          NewReportScreen.of(context)?.repeatingReport = selectedValues;
        });
        _multiSelectKey.currentState?.validate();
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            selectedValues.remove(value);
            NewReportScreen.of(context)?.repeatingReport = selectedValues;
          });
          _multiSelectKey.currentState?.validate();
        },
      ),
    );
  }
}
