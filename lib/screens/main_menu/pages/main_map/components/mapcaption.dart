import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../../logic/classes/report.dart';

class MapCaption extends StatelessWidget {
  final List<Report> reportsList;

  const MapCaption({Key? key,
                    required this.reportsList,
                    }) : super(key: key);

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
          rows: reportsList.map((e) =>
              DataRow(
                cells: [
                  DataCell(
                    Icon(e.groups[0].icon, color: e.groups[0].color),
                  ),
                  DataCell(
                    Text(e.groups[0].name),
                  ),
                ],
              ),
          ).toList(),
        ),
      ),
    );
  }
}
