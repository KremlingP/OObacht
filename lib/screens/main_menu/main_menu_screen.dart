import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oobacht/screens/main_menu/pages/main_list/main_list.dart';
import 'package:oobacht/screens/new_report/new_report_screen.dart';
import 'package:oobacht/widgets/map/map_widget.dart';

import '../../../../utils/navigator_helper.dart' as navigator;
import '../../logic/classes/group.dart';
import '../../logic/classes/report.dart';
import 'drawer/main_menu_drawer.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool darkMode = false;

  //PageController to make pages swipeable
  final _pageViewController = PageController();
  int _activePageIndex = 0;
  final List<Widget> _contentPages = [
    MapWidget(
      reports: _getMockReports(),
      showMarkerDetails: true,
      showMapCaption: true,
    ),
    MainList(reports: _getMockReports())
  ];

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
        title: const Text(
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
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _drawerKey.currentState!.openDrawer()),
          IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () => _drawerKey.currentState!.openDrawer()),
        ],
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Neue Meldung'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: _newReport,
        tooltip: 'Neue Meldung erstellen',
        elevation: 4.0,
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  void _newReport() {
    navigator.navigateToNewScreen(
        newScreen: NewReportScreen(
          reports: _getMockReports(),
        ),
        context: context);
  }

  static List<Report> _getMockReports() {
    return [
      Report(
          "1",
          "Krasse Meldung",
          "Ich hab etwas wirklich krasses gefunden, deshalb muss ich erst mal richtig viel Text drüber schreiben um meine UI testen zu können!",
          DateTime.now(),
          [
            Group("1", "Mathematiker", Icons.add, Colors.blue),
            Group("2", "Speicherwütiger!", Icons.save, Colors.green),
            Group("3", "Was auch immer?!", Icons.person, Colors.blueGrey),
            Group("4", "Gute Frage", Icons.ten_k, Colors.yellow),
          ],
          const LatLng(48.455166, 8.706739),
          "http://"),
      Report(
          "2",
          "Richtig langer Name der Meldung was geht denn hier ab??!?!?",
          "Diese Meldung hat kein Bild hinterlegt, darum keine Anzeige oben!",
          DateTime.now(),
          [
            Group("1", "Mathematiker", Icons.add, Colors.blue),
          ],
          const LatLng(48.435166, 8.706739),
          ""),
      Report(
          "3",
          "Dritte Meldung, die komplett mit ihrem Titel übers Ziel hinaus schießt und hoffentlich richtig angezeigt wird",
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et e",
          DateTime.now(),
          [
            Group("5", "Uhrwerker", Icons.watch, Colors.red),
          ],
          const LatLng(48.445166, 8.716739),
          "http://"),
    ];
  }
}
