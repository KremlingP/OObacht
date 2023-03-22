import 'package:flutter/material.dart';
import 'package:oobacht/screens/drawer/components/drawer_page_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/theme.dart';

class SettingsDrawerPage extends StatefulWidget {
  const SettingsDrawerPage({Key? key}) : super(key: key);

  @override
  _SettingsDrawerPageState createState() => _SettingsDrawerPageState();
}

class _SettingsDrawerPageState extends State<SettingsDrawerPage> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const DrawerPageAppBar(
        title: "Einstellungen",
      ),
      body: SafeArea(
        child: Center(
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
      ),
    );
  }

  void saveDataToSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', darkMode);
  }
}
