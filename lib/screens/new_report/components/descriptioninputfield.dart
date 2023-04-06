import 'dart:io';

import 'package:flutter/material.dart';

import '../new_report_screen.dart';

class DescriptionInputField extends StatefulWidget {
  const DescriptionInputField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DescriptionInputFieldState();
}

class _DescriptionInputFieldState extends State<DescriptionInputField> {
  String description = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      maxLength: 500,
      autocorrect: true,
      onChanged: (value) => {
        description = value ?? "",
        NewReportScreen.of(context)?.description = description
      },
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
    );
  }
}
