import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatelessWidget {
  const ReportDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      body: SafeArea(
        child: Container(
          color: theme.colorScheme.background,
        ),
      ),
    );
  }
}
