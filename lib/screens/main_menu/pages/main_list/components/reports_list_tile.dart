import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';
import 'package:oobacht/utils/helper_methods.dart';
import 'package:oobacht/utils/navigator_helper.dart' as navigator;

class ReportsListTile extends StatelessWidget {
  final Report data;
  final VoidCallback refreshMethod;

  const ReportsListTile(
      {Key? key, required this.data, required this.refreshMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => goToReportDetails(context, data),
      child: Card(
        elevation: 5.0,
        child: Container(
          color: theme.colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Header row: title and timestamp
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Title and institution
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data.institution.isNotEmpty
                            ? Row(
                                children: [
                                  Text(
                                    "${data.institution} ",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const Icon(Icons.verified,
                                      color: Colors.blue),
                                ],
                              )
                            : Container(),
                        Text(
                          data.title,
                          maxLines: data.institution.isNotEmpty ? 1 : 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: theme.primaryColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),

                    ///Timestamp
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.event,
                              color: Colors.orange,
                            ),
                            Text(" ${getDisplayDate(data.creationDate!)}",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                color: Colors.orange,
                              ),
                              Text(" ${data.distance!.toStringAsFixed(2)} km entfernt",
                                  style: const TextStyle(
                                    color: Colors.orange,
                                  ),
                                  maxLines: 1),
                            ]
                        ),
                      ],
                    )
                  ],
                ),
              ),

              ///Body row 1: excerpt of description
              Text(
                data.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: theme.primaryColor),
              ),

              ///Body row 2: groups
              Wrap(
                spacing: 5.0,
                runSpacing: -10.0,
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: getGroupChips(data.groups),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToReportDetails(BuildContext context, Report data) {
    navigator
        .navigateToNewScreen(
            newScreen: ReportDetailsScreen(reportData: data), context: context)
        .then((value) => {refreshMethod()});
  }
}
