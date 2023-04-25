import 'package:flutter/material.dart';

import '/utils/list_unique.dart';
import '../../../../../logic/classes/report.dart';

class MapCaption extends StatelessWidget {
  final List<Report> reportsList;

  MapCaption({
    Key? key,
    required this.reportsList,
  }) : super(key: key);

  bool multipleCategoriesSet = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 10,
      left: 10,
      height: 105,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowHeight: 0,
          dataRowHeight: 25,
          dataRowColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(147, 150, 153, 0.5)),
          columnSpacing: 1,
          border: TableBorder.all(
            color: Colors.transparent,
          ),
          columns: const [
            DataColumn(label: Text('Icon')),
            DataColumn(label: Text('NAME')),
          ],
          rows: reportsList
              .map((e) => getDataRowForReport(e, theme))
              .toList()
              //compares toString of child => name of group and eliminates duplicates
              .unique((dr) => dr.cells.last.child.toString()),
        ),
      ),
    );
  }

  DataRow getDataRowForReport(Report report, ThemeData theme) {
    if (report.groups.length > 1 && !multipleCategoriesSet) {
      multipleCategoriesSet = true;
      return DataRow(
        cells: [
          const DataCell(
            Icon(Icons.category, color: Colors.grey),
          ),
          DataCell(
            Text("Mehrere Kategorien",
                style: TextStyle(color: theme.primaryColor)),
          ),
        ],
      );
    }
    return DataRow(
      cells: [
        DataCell(
          ImageIcon(report.groups[0].icon, color: report.groups[0].color),
        ),
        DataCell(
          Text(report.groups[0].name,
              style: TextStyle(color: theme.primaryColor)),
        ),
      ],
    );
  }
}
