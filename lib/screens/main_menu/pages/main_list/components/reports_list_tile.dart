import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';

class ReportsListTile extends StatelessWidget {
  final Report data;

  const ReportsListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 10,
      margin: const EdgeInsets.all(10),
    );
  }
}
