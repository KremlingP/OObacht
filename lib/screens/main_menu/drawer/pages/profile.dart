import 'package:flutter/material.dart';

import '../components/drawer_page_app_bar.dart';

class ProfileDrawerPage extends StatefulWidget {
  const ProfileDrawerPage({Key? key}) : super(key: key);

  @override
  _ProfileDrawerPageState createState() => _ProfileDrawerPageState();
}

class _ProfileDrawerPageState extends State<ProfileDrawerPage> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const DrawerPageAppBar(
        title: "Profil",
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
