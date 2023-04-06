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
          child: Icon(group.icon, color: Colors.white),
        ),
      ),
    );
  }

  return chips;
}

List<Widget> getRepeatingChips(List<RepeatingReportsEnum> repeatingList, ThemeData theme) {
  List<Widget> chips = [];
  for (RepeatingReportsEnum value in repeatingList) {
    chips.add(
        Chip(
          label: Text(
            getRepeatingReportName(value),
            style: TextStyle(color: theme.primaryColor),
          ),
          backgroundColor: getRepeatingReportColor(value),
          avatar: CircleAvatar(
            backgroundColor: getRepeatingReportColor(value),
            child:
            Icon(getRepeatingReportIcon(value), color: theme.primaryColor),
          ),
        ),
    );
  }

  return chips;
}
