import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/theme.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const AutoSizeText(
          'OOBACHT!',
          style: TextStyle(fontFamily: 'Fredoka', color: Colors.white),
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Darkmode",
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
            Switch(
              value: theme.colorScheme.background ==
                  CustomTheme.darkTheme.colorScheme.background,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                  currentTheme.toggleTheme();
                  saveDataToSharedPrefs();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void saveDataToSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', darkMode);
  }
}
