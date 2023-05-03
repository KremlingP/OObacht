import 'package:flutter/material.dart';
import 'package:oobacht/globals.dart' as globals;
import 'package:oobacht/logic/services/pushnotificationsservice.dart';
import 'package:oobacht/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/drawer_page_app_bar.dart';

class SettingsDrawerPage extends StatefulWidget {
  const SettingsDrawerPage({Key? key}) : super(key: key);

  @override
  _SettingsDrawerPageState createState() => _SettingsDrawerPageState();
}

class _SettingsDrawerPageState extends State<SettingsDrawerPage> {
  ThemeMode selectedThemeMode = ThemeMode.light;

  @override
  void initState() {
    selectedThemeMode = globals.globalThemeMode;
    super.initState();
  }

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
                  "Darkmode Einstellung",
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
              DropdownButton(
                value: selectedThemeMode,
                icon: Icon(
                  Icons.colorize,
                  color: theme.primaryColor,
                ),
                dropdownColor: theme.colorScheme.background,
                style: TextStyle(color: theme.primaryColor),
                onChanged: (ThemeMode? value) {
                  setState(() {
                    selectedThemeMode = value!;
                    currentTheme.toggleTheme(selectedThemeMode);
                    saveDataToSharedPrefs();
                  });
                },
                items: dropdownItems,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Push-Benachrichtigungen",
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
              Switch(
                value: globals.pushNotificationsActivated,
                onChanged: (value) {
                  setState(() {
                    globals.pushNotificationsActivated = value;
                    saveDataToSharedPrefs();
                    PushNotificationService.sendSavedFcmTokenToServer();
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
    prefs.setString('themeMode', selectedThemeMode.name);
    prefs.setBool('pushNotifications', globals.pushNotificationsActivated);
  }

  List<DropdownMenuItem<ThemeMode>> get dropdownItems {
    List<DropdownMenuItem<ThemeMode>> menuItems = [
      const DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
      const DropdownMenuItem(value: ThemeMode.light, child: Text("Hell")),
      const DropdownMenuItem(value: ThemeMode.dark, child: Text("Dunkel")),
    ];
    return menuItems;
  }
}
