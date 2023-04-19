import 'package:flutter/material.dart';
import 'package:oobacht/screens/main_menu/drawer/components/logout_list_tile.dart';

import '../../../logic/classes/group.dart';
import 'components/drawer_list_tile.dart';
import 'pages/informations.dart';
import 'pages/profile.dart';
import 'pages/settings.dart';

class MainMenuDrawer extends StatelessWidget {
  const MainMenuDrawer({Key? key, required this.categories}) : super(key: key);

  final List<Group> categories;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'OObacht! 0.0.1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            DrawerListTile(
              text: 'Profil',
              icon: Icons.person,
              context: context,
              site: const ProfileDrawerPage(),
            ),
            DrawerListTile(
              text: 'Einstellungen',
              icon: Icons.settings,
              context: context,
              site: const SettingsDrawerPage(),
            ),
            DrawerListTile(
              text: 'Informationen',
              icon: Icons.info_outline,
              context: context,
              site: const InformationsDrawerPage(),
            ),
            const LogoutListTile(),
          ],
        ),
      ),
    );
  }
}
