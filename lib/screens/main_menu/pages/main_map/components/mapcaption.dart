import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../../logic/classes/report.dart';

class MapCaption extends StatelessWidget {
  final List<Report> reportsList;

  MapCaption({Key? key,
                    required this.reportsList,
                    }) : super(key: key);

  bool multipleCategoriesSet = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      height: 105,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          headingRowHeight: 0,
          dataRowHeight: 25,
          dataRowColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(147, 150, 153, 0.5)),
          columnSpacing: 1,
          border: TableBorder.all(
            color: Colors.transparent,
          ),
          columns: const [
            DataColumn(
                label: Text('Icon')
            ),
            DataColumn(
                label: Text('NAME')
            ),
          ],
          rows: reportsList.map((e) => getDataRowForReport(e)).toList(),
        ),
      ),
    );
  }

  DataRow getDataRowForReport(Report report) {
    if(report.groups.length > 1 && !multipleCategoriesSet) {
      multipleCategoriesSet = true;
      return const DataRow(
        cells: [
          DataCell(
            Icon(Icons.category, color: Colors.grey),
          ),
          DataCell(
            Text("Mehrere Kategorien"),
          ),
        ],
      );
    }
    return DataRow(
      cells: [
        DataCell(
          Icon(report.groups[0].icon, color: report.groups[0].color),
        ),
        DataCell(
          Text(report.groups[0].name),
        ),
      ],
    );
  }
}
