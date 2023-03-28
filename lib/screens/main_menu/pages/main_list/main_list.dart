import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/main_menu/pages/main_list/components/reports_list_tile.dart';

class MainList extends StatefulWidget {
  const MainList({Key? key}) : super(key: key);

  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  final List<Report> _mockReports = _getMockReports();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(5.0),
      color: theme.colorScheme.background,
      child: ListView.builder(
        itemCount: _mockReports.length,
        itemBuilder: (context, index) {
          return ReportsListTile(data: _mockReports[index]);
        },
      ),
    );
  }

  static List<Report> _getMockReports() {
    return [
      Report(
          "1",
          "Krasse Meldung",
          "Ich hab etwas wirklich krasses gefunden, deshalb muss ich erst mal richtig viel Text drüber schreiben um meine UI testen zu können!",
          DateTime.now(),
          [
            Group("1", "Mathematiker", Icons.add, Colors.blue),
            Group("2", "Speicherwütiger!", Icons.save, Colors.green),
            Group("3", "Was auch immer?!", Icons.person, Colors.blueGrey),
            Group("4", "Gute Frage", Icons.ten_k, Colors.yellow),
          ],
          const LatLng(48.445166, 8.706739),
          "http://"),
      Report(
          "2",
          "Richtig langer Name der Meldung was geht denn hier ab??!?!?",
          "Diese Meldung hat kein Bild hinterlegt, darum keine Anzeige oben!",
          DateTime.now(),
          [
            Group("1", "Mathematiker", Icons.add, Colors.blue),
          ],
          const LatLng(48.445166, 8.706739),
          ""),
      Report(
          "3",
          "Dritte Meldung, die komplett mit ihrem Titel übers Ziel hinaus schießt und hoffentlich richtig angezeigt wird",
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et e",
          DateTime.now(),
          [
            Group("5", "Uhrwerker", Icons.watch, Colors.red),
          ],
          const LatLng(48.445166, 8.706739),
          "http://"),
    ];
  }
}
