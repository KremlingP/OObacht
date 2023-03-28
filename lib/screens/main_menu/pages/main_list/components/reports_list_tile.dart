import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';
import 'package:oobacht/utils/helper_methods.dart';
import 'package:oobacht/utils/navigator_helper.dart' as navigator;
import 'package:oobacht/widgets/text_styles/bold_text_style.dart';

class ReportsListTile extends StatelessWidget {
  final Report data;

  const ReportsListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: InkWell(
        onTap: () => goToReportDetails(context, data),
        child: Card(
          elevation: 5.0,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: media.size.shortestSide / 3.2,
            child: Column(
              children: [
                ///Header row: title and timestamp
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: media.size.width / 2,
                          child: BoldText(text: data.title, maxLines: 2)),
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
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
                  height: 20,
                  child: Text(
                    data.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                ///Body row 2: groups
                SizedBox(
                    height: 35,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _getGroupChips(data.groups),
                      ),
                    ))
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
        Container(
          margin: const EdgeInsets.symmetric(vertical: 3.0),
          child: CircleAvatar(
            backgroundColor: group.color,
            child: Icon(group.icon, color: Colors.white),
          ),
        ),
      );
    }

    return chips;
  }
}
