import 'dart:io';

import 'package:flutter/material.dart';

import '../new_report_screen.dart';

class TitleInputField extends StatefulWidget {

  const TitleInputField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TitleInputFieldState();
}

class _TitleInputFieldState extends State<TitleInputField> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLines: 1,
      maxLength: 50,
      autocorrect: true,
      onSaved: (value) => {
        title = value ?? "",
        NewReportScreen.of(context)?.title = title
      },
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
    );
  }
}