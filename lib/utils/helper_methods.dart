import 'package:flutter/material.dart';

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
