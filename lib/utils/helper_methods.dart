import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/repeating_reports_enum.dart';

import '../logic/classes/group.dart';

String getDisplayDate(DateTime dateTime) {
  return '${dateTime.day < 10 ? '0' : ''}${dateTime.day}.${dateTime.month < 10 ? '0' : ''}${dateTime.month}.${dateTime.year}';
}

List<Widget> getGroupChips(List<Group> groups) {
  List<Widget> chips = [];
  for (Group group in groups) {
    chips.add(
      Chip(
        label: Text(
          group.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: group.color,
        avatar: CircleAvatar(
          backgroundColor: group.color,
          child: ImageIcon(group.icon, color: Colors.white),
        ),
      ),
    );
  }

  return chips;
}

List<Widget> getRepeatingChips(
    List<RepeatingReportsEnum> repeatingList, ThemeData theme) {
  List<Widget> chips = [];
  for (RepeatingReportsEnum value in repeatingList) {
    chips.add(
      Chip(
        label: Text(
          getRepeatingReportName(value),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: getRepeatingReportColor(value),
        avatar: CircleAvatar(
          backgroundColor: getRepeatingReportColor(value),
          child: Icon(getRepeatingReportIcon(value), color: Colors.white),
        ),
      ),
    );
  }

  return chips;
}

void showLoadingSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

void showResponseSnackBar(BuildContext context, bool successful,
    String successString, String failString) {
  if (successful) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successString),
        duration: const Duration(seconds: 3),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failString),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
