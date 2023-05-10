import 'package:flutter/material.dart';

import '../components/drawer_page_app_bar.dart';

class InformationsDrawerPage extends StatelessWidget {
  const InformationsDrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: const DrawerPageAppBar(title: "Informationen"),
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
                  "by OObacht! Group",
                  style: TextStyle(color: theme.primaryColor),
                ),
                Text(
                  "Ein großer Dank geht an Torsten! Ohne ihn hätten unsere Bilder noch immer eine schlechte Qualität!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.primaryColor,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }
}
