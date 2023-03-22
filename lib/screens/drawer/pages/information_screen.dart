import 'package:flutter/material.dart';
import 'package:oobacht/screens/drawer/components/drawer_page_app_bar.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: const DrawerPageAppBar(title: "INFORMATIONEN"),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "OOBACHT!",
                      style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 40,
                          color: theme.primaryColor),
                    ),
                    Text(
                      "v 0.0.1",
                      style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 20,
                          color: theme.primaryColor),
                    ),
                    Text(
                      "Die Warn-App deines Vertrauens!",
                      style: TextStyle(fontSize: 20, color: theme.primaryColor),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/logo.png',
                  height: data.size.shortestSide / 5,
                  width: data.size.shortestSide / 1.4,
                ),
                Text(
                  "by OOBacht! Group",
                  style: TextStyle(color: theme.primaryColor),
                )
              ],
            ),
          ),
        ));
  }
}
