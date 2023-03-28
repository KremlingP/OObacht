import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:oobacht/logic/classes/report.dart';

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
        title: const AutoSizeText(
          "Meldung",
          style: TextStyle(fontFamily: 'Fredoka', color: Colors.white),
          maxLines: 1,
        ),
        centerTitle: true,
      ),
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
                    const SizedBox(height: 10.0),

                    ///Groups
                    Wrap(
                      spacing: 8.0,
                      runSpacing: -6.0,
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: HelperMethods.getGroupChips(reportData.groups),
                    ),
                    const SizedBox(height: 5.0),

                    ///Description
                    Text(
                      reportData.description,
                      style: TextStyle(color: theme.primaryColor),
                      overflow: TextOverflow.visible,
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
