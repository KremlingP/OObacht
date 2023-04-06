import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RepeatingReportsEnum {
  rain,
  wind,
  hot,
  frost,
  snow,
  thunder,
  hail,
  fog,
}

String getRepeatingReportName(RepeatingReportsEnum repeatingReport) {
  switch (repeatingReport) {
    case RepeatingReportsEnum.rain:
      return "Regen";
    case RepeatingReportsEnum.wind:
      return "Wind";
    case RepeatingReportsEnum.hot:
      return "Hitze";
    case RepeatingReportsEnum.frost:
      return "Frost";
    case RepeatingReportsEnum.snow:
      return "Schnee";
    case RepeatingReportsEnum.thunder:
      return "Gewitter";
    case RepeatingReportsEnum.hail:
      return "Hagel";
    case RepeatingReportsEnum.fog:
      return "Nebel";
  }
}

IconData getRepeatingReportIcon(RepeatingReportsEnum repeatingReport) {
  switch (repeatingReport) {
    case RepeatingReportsEnum.rain:
      return Icons.cloud;
    case RepeatingReportsEnum.wind:
      return Icons.wind_power;
    case RepeatingReportsEnum.hot:
      return Icons.local_fire_department;
    case RepeatingReportsEnum.frost:
      return Icons.ac_unit;
    case RepeatingReportsEnum.snow:
      return Icons.cloudy_snowing;
    case RepeatingReportsEnum.thunder:
      return Icons.thunderstorm;
    case RepeatingReportsEnum.hail:
      return Icons.cloudy_snowing;
    case RepeatingReportsEnum.fog:
      return Icons.foggy;
  }
}

Color getRepeatingReportColor(RepeatingReportsEnum repeatingReport) {
  switch (repeatingReport) {
    case RepeatingReportsEnum.rain:
      return Colors.blue;
    case RepeatingReportsEnum.wind:
      return Colors.blueGrey;
    case RepeatingReportsEnum.hot:
      return Colors.red;
    case RepeatingReportsEnum.frost:
      return Colors.lightBlue;
    case RepeatingReportsEnum.snow:
      return Colors.blueAccent;
    case RepeatingReportsEnum.thunder:
      return Colors.orange;
    case RepeatingReportsEnum.hail:
      return Colors.white12;
    case RepeatingReportsEnum.fog:
      return Colors.white10;
  }
}