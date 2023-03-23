import 'package:flutter/material.dart';
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
            height: 100,
            child: Column(
              children: [
                ///Header row: title and timestamp
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: media.size.width / 2,
                          child: BoldText(text: data.title, maxLines: 1)),
                      Chip(
                        avatar: const Icon(Icons.add),
                        label: NormalText(
                            text:
                                HelperMethods.getDisplayDate(data.creationDate),
                            maxLines: 1),
                      ),
                    ],
                  ),
                ),

                ///Body row: groups and description excerpt with button to go to details
                Expanded(
                  flex: 3,
                  child: NormalText(
                    text: data.description,
                    maxLines: 1,
                  ),
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
}
