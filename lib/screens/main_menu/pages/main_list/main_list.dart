import 'package:flutter/material.dart';
import 'package:oobacht/screens/report_details/report_details_screen.dart';

import '../../../../utils/navigator_helper.dart' as navigator;

class MainList extends StatefulWidget {
  const MainList({Key? key}) : super(key: key);

  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Liste"),
          const Icon(Icons.list),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            ),
            onPressed: () {
              navigator.navigateToNewScreen(
                  newScreen: const ReportDetailsScreen(), context: context);
            },
            child: const Text('Detail'),
          ),
        ],
      ),
    );
  }
}
