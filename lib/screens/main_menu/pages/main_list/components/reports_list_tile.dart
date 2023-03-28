import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';
import 'package:oobacht/utils/helper_methods.dart';
import 'package:oobacht/utils/navigator_helper.dart' as navigator;

class ReportsListTile extends StatelessWidget {
  final Report data;

  const ReportsListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () => goToReportDetails(context, data),
        child: Card(
          elevation: 5.0,
          child: Container(
            color: theme.colorScheme.background,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ///Header row: title and timestamp
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Title
                      Expanded(
                          child: Text(
                        data.title,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: theme.primaryColor),
                        overflow: TextOverflow.ellipsis,
                      )),

                      ///Timestamp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.event,
                            color: Colors.orange,
                          ),
                          Text(
                              " ${HelperMethods.getDisplayDate(data.creationDate)}",
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1),
                        ],
                      )
                    ],
                  ),
                ),

                ///Body row 1: excerpt of description
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    data.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),

                ///Body row 2: groups
                Wrap(
                  spacing: 8.0,
                  runSpacing: -6.0,
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: _getGroupChips(data.groups),
                ),
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

  List<Widget> _getGroupChips(List<Group> groups) {
    List<Widget> chips = [];
    for (Group group in groups) {
      chips.add(
        Chip(
          label: Text(
            group.name,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: group.color,
          avatar: CircleAvatar(
            backgroundColor: group.color,
            child: Icon(group.icon, color: Colors.white),
          ),
        ),
      );
    }

    return chips;
  }
}
