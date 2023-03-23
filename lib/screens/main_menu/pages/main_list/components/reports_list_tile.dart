import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';
import 'package:oobacht/utils/navigator_helper.dart' as navigator;

class ReportsListTile extends StatelessWidget {
  final Report data;

  const ReportsListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () => goToReportDetails(context, data),
        child: Card(
          elevation: 5.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 75,
            child: Column(
              children: [
                Text(data.title),
                Text(data.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToReportDetails(BuildContext context, Report data) {
    navigator.navigateToNewScreen(
        newScreen: const ReportDetailsScreen(), context: context);
  }
}
