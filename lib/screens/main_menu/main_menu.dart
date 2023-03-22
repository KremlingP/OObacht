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

  //PageController to make pages swipeable
  final _pageViewController = PageController();
  int _activePageIndex = 0;
  final List<Widget> _contentPages = [const MainMap(), const MainList()];

  @override
  void dispose() {
    //dispose PageController to stop bugs
    _pageViewController.dispose();
    super.dispose();
  }

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
          child: PageView(
        controller: _pageViewController,
        children: _contentPages,
        onPageChanged: (index) {
          setState(() {
            _activePageIndex = index;
          });
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activePageIndex,
        onTap: _onItemTapped,
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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(
      () {
        _activePageIndex = index;
      },
    );
    _pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
  }
}
