import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/main_menu/pages/main_list/components/reports_list_tile.dart';

class MainList extends StatefulWidget {
  const MainList({Key? key, required this.reports, required this.refreshMethod})
      : super(key: key);

  final List<Report> reports;
  final VoidCallback refreshMethod;

  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        color: theme.colorScheme.background,
        child: widget.reports.isNotEmpty
            ? ListView.builder(
                itemCount: widget.reports.length,
                itemBuilder: (context, index) {
                  return ReportsListTile(
                    data: widget.reports[index],
                    refreshMethod: widget.refreshMethod,
                  );
                },
              )
            : ListView(
                padding: const EdgeInsets.only(top: 20.0),
                children: [
                  Text(
                    "Keine passenden Meldungen gefunden!\n Zum Aktualisieren nach unten ziehen!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      widget.refreshMethod();
    });
  }
}
