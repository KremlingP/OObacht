import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';
import 'package:oobacht/widgets/map/map_widget.dart';

import '../../logic/classes/repeating_reports_enum.dart';
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
            PopupMenuButton(
                icon: const Icon(Icons.error),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      textStyle: TextStyle(color: theme.primaryColor),
                      child: const Text("Als veraltet melden"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      textStyle: TextStyle(color: theme.primaryColor),
                      child: const Text("Als unangemessen melden"),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    //TODO "Veraltet" ans Backend senden
                  } else if (value == 1) {
                    //TODO "Unangemessen" ans Backend senden
                  }
                }),
          ]),
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///Show Picture if not null or empty
              reportData.imageUrl == null || reportData.imageUrl.isEmpty
                  ? Container()
                  : SizedBox(
                      height: shortestViewportWidth * 0.5,
                      child: Container(
                        color: Colors.cyanAccent,
                      ),
                      // child: Image.file(
                      //   imageFile!,
                      //   fit: BoxFit.cover,
                      // ),
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
