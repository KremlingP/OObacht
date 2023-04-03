import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/main_menu/pages/main_list/components/reports_list_tile.dart';

class MainList extends StatefulWidget {
  const MainList({Key? key, required this.reports}) : super(key: key);

  final List<Report> reports;

  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(5.0),
      color: theme.colorScheme.background,
      child: widget.reports.isNotEmpty
          ? ListView.builder(
              itemCount: widget.reports.length,
              itemBuilder: (context, index) {
                return ReportsListTile(data: widget.reports[index]);
              },
            )
          : Center(
              child: Text(
                "Keine Meldungen gefunden!",
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
    );
  }
}
