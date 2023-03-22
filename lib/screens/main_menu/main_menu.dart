import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:oobacht/screens/main_list/main_list.dart';
import 'package:oobacht/screens/main_map/main_map.dart';

import 'drawer/main_menu_drawer.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool darkMode = false;
  int _selectedIndex = 0;

  final List<Widget> _contentPages = [const MainMap(), const MainList()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double viewportWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _drawerKey,
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const AutoSizeText(
          'OObacht!',
          style: TextStyle(
              fontFamily: 'Courgette',
              color: Colors.white,
              fontWeight: FontWeight.w900),
          maxLines: 1,
        ),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _drawerKey.currentState!.openDrawer()),
      ),
      drawer: SizedBox(
        width: viewportWidth * 0.65,
        child: const MainMenuDrawer(),
      ),
      body: SafeArea(
        child: _contentPages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Karte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }
}
