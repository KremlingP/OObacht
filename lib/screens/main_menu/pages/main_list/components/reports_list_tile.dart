import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/group.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';
import 'package:oobacht/utils/helper_methods.dart';
import 'package:oobacht/utils/navigator_helper.dart' as navigator;
import 'package:oobacht/widgets/text_styles/bold_text_style.dart';
import 'package:oobacht/widgets/text_styles/normal_text_style.dart';

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
            height: media.size.shortestSide / 3,
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
                          child: BoldText(text: data.title, maxLines: 1)),
                      Chip(
                        avatar: const Icon(Icons.event),
                        label: NormalText(
                            text:
                                HelperMethods.getDisplayDate(data.creationDate),
                            maxLines: 1),
                      ),
                    ],
                  ),
                ),

                ///Body row: groups and description excerpt with button to go to details
                Container(
                  margin: const EdgeInsets.only(bottom: 5.0),
                  height: 20,
                  child: Text(
                    data.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
      chips.add(Container(
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        child: Chip(
          backgroundColor: group.color,
          avatar: Icon(group.icon, color: Colors.white),
          label: Text(
            group.name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ));
    }

    return chips;
  }
}
