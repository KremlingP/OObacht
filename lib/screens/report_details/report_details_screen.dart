import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';
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
            PopupMenuButton(
                icon: const Icon(Icons.error),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Als veraltet melden"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Als unangemessen melden"),
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
                    )
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
