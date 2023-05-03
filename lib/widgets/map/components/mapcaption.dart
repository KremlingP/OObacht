import 'package:flutter/material.dart';
import 'package:oobacht/utils/list_unique.dart';

import '../../../../../logic/classes/report.dart';

class MapCaption extends StatelessWidget {
  final List<Report> reportsList;

  MapCaption({
    Key? key,
    required this.reportsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 10,
      left: 10,
      height: 103,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowHeight: 0,
          dataRowHeight: 25,
          dataRowColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(255, 255, 255, 0.50)),
          columnSpacing: 1,
          border: TableBorder.all(
            color: Colors.transparent,
          ),
          columns: const [
            DataColumn(label: Text('Icon')),
            DataColumn(label: Text('NAME')),
          ],
          rows: reportsList.map((e) => getDataRowForReport(e, theme)).toList()
          .unique((element) {
            Text textWidget = element.cells.last.child as Text;
            return textWidget.data;
          }),
        ),
      ),
    );
  }

  DataRow getDataRowForReport(Report report, ThemeData theme) {
    if (report.groups.length > 1) {
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

  List<DataRow> _getDataRows(ThemeData theme) {
    List<DataRow> dataRows = [];
    for (var report in reportsList) {
      DataRow newRow = getDataRowForReport(report, theme);
      if (!dataRows
          .any((element) {
            Text firstElement = element.cells.last.child as Text;
            Text secondElement = newRow.cells.last.child as Text;
        print('>>> Comparing ${firstElement.data} with ${secondElement.data}');
        return firstElement.data == secondElement.data;
          })) {
        dataRows.add(newRow);
        print(">>> Added new row");
      }
    }
    return dataRows;
  }
}
