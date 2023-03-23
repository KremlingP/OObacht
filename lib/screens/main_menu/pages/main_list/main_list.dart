import 'package:flutter/material.dart';
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
            Group("1", Icons.add, "Mathematiker"),
            Group("2", Icons.save, "Speicher")
          ],
          "http://"),
      Report(
          "2",
          "Richtig langer Name der Meldung was geht denn hier ab??!?!?",
          "Kurzer Text",
          DateTime.now(),
          [Group("1", Icons.add, "Mathematiker")],
          "http://"),
      Report("3", "Dritte Meldung", "Beispiel", DateTime.now(),
          [Group("1", Icons.add, "Mathematiker")], "http://"),
    ];
  }
}
