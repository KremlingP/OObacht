import 'package:flutter/material.dart';
import 'package:oobacht/firebase/functions/report_functions.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/utils/dialoges.dart';
import 'package:oobacht/widgets/map/map_widget.dart';

import '../../utils/helper_methods.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report reportData;

  const ReportDetailsScreen({Key? key, required this.reportData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double shortestViewportWidth = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Meldung",
            style: TextStyle(fontFamily: 'Fredoka', color: Colors.white),
            maxLines: 1,
          ),
          centerTitle: true,
          actions: [
            reportData.isOwnReport
                ? Container()
                : PopupMenuButton(
                    icon: const Icon(Icons.error),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          textStyle: TextStyle(color: theme.primaryColor),
                          child: const Text("Als veraltet melden"),
                          onTap: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Deine Meldung wird übermittelt...'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            bool success =
                                await ReportFunctions.createConcluded(
                                    reportData.id!);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Die Meldung wurde als veraltet gemeldet.'),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Du hast diese Meldung bereits gemeldet.'),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          textStyle: TextStyle(color: theme.primaryColor),
                          child: const Text("Als unangemessen melden"),
                          onTap: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Deine Meldung wird übermittelt...'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            bool success =
                                await ReportFunctions.createComplaint(
                                    reportData.id!);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Die Meldung wurde als unangemessen gemeldet.'),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Du hast diese Meldung bereits gemeldet.'),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ];
                    }),
          ]),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///Show Picture if not null or empty
              reportData.image == null || reportData.image.isEmpty
                  ? Container()
                  : SizedBox(
                      height: shortestViewportWidth * 0.5,
                      child: Image.network(
                        reportData.image,
                        fit: BoxFit.cover,
                      ),
                    ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///Title
                    Text(
                      reportData.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: theme.primaryColor),
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 5.0),

                    ///Groups
                    Wrap(
                      spacing: 8.0,
                      runSpacing: -6.0,
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: getGroupChips(reportData.groups),
                    ),
                    const SizedBox(height: 5.0),

                    ///Description
                    Text(
                      reportData.description,
                      style: TextStyle(color: theme.primaryColor),
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 10.0),

                    ///Map
                    Container(
                      height: shortestViewportWidth * 0.66,
                      width: shortestViewportWidth * 0.66,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 3.0)),
                      child: MapWidget(
                        reports: [reportData],
                        showMarkerDetails: false,
                        showMapCaption: false,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    /// Repeating report
                    reportData.repeatingReport.isEmpty
                        ? Container()
                        : Center(
                            child: Column(
                              children: [
                                Text(
                                    "Diese Meldung wird wiederholt ausgelöst bei:",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                    )),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: -6.0,
                                  alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,
                                  children: getRepeatingChips(
                                      reportData.repeatingReport, theme),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 20.0),

                    /// Alternatives
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 3.0)),
                      child: Column(
                        children: [
                          Center(
                            child: Text("Alternativen",
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 20,
                                )),
                          ),
                          const SizedBox(height: 10),
                          reportData.alternatives.isNotEmpty
                              ? SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    itemCount: reportData.alternatives.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          foregroundColor: theme.primaryColor,
                                          child: Text('${index + 1}'),
                                        ),
                                        title: Text(
                                            reportData.alternatives[index],
                                            style: TextStyle(
                                                color: theme.primaryColor)),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text("Keine Alternativen hinzugefügt.",
                                      style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 15))),
                        ],
                      ),
                    ),

                    ///Delete Button (only showed if isOwnReport)
                    reportData.isOwnReport
                        ? Container(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              onPressed: () => _deleteReport(context),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              child: const Text(
                                "Meldung löschen",
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteReport(BuildContext context) async {
    //Approve Dialog
    final action = await Dialogs.yesAbortDialog(
        context,
        Icons.delete,
        "Meldung löschen?",
        "Wollen Sie die Meldung wirklich unwiderruflich löschen?");
    if (action == DialogAction.yes) {
      showLoadingSnackBar(context, 'Löschen wird übermittelt...');
      bool successful = await ReportFunctions.deleteReport(reportData.id!);
      showResponseSnackBar(
          context,
          successful,
          'Meldung wurde erfolgreich gelöscht!',
          'Fehler beim Löschen der Meldung!');
      Navigator.pop(context);
    }
  }
}
