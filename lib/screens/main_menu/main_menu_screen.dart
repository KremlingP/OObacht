import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oobacht/logic/classes/repeating_reports_enum.dart';
import 'package:oobacht/screens/main_menu/pages/main_list/main_list.dart';
import 'package:oobacht/screens/new_report/new_report_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../utils/navigator_helper.dart' as navigator;
import '../../firebase/functions/report_functions.dart';
import '../../logic/classes/group.dart';
import '../../logic/classes/report.dart';
import '../../widgets/error_text.dart';
import '../../widgets/loading_hint.dart';
import '../../widgets/map/map_widget.dart';
import 'drawer/main_menu_drawer.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<Report> allReports = _getMockReports();
  List<Report> filteredReports = [];

  //PageController to make pages swipeable
  final _pageViewController = PageController();
  int _activePageIndex = 0;

  //for search bar and filtering
  final TextEditingController _searchQueryController = TextEditingController();
  String queryText = "";
  bool _isSearching = false;
  List<Group> allGroups = _getGroupsMock();
  List<Group> selectedGroups = [];
  bool showOnlyOwn = false;

  @override
  void initState() {
    filteredReports = allReports;
    super.initState();
  }

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
              leading: _isSearching ? const BackButton() : _buildLeading(),
              title: _isSearching ? _buildSearchField() : _buildTitle(),
              actions: _buildActions(theme),
              centerTitle: true,
            ),
            drawer: SizedBox(
              width: viewportWidth * 0.65,
              child: const MainMenuDrawer(),
            ),
            body: SafeArea(
                child: PageView(
                  controller: _pageViewController,
                  children: [
                    MapWidget(
                      reports: filteredReports,
                      showMarkerDetails: true,
                      showMapCaption: true,
                    ),
                    MainList(reports: filteredReports),
                  ],
              onPageChanged: (index) {
                setState(() {
                  _activePageIndex = index;
                });
              },
            )),
            floatingActionButton: FloatingActionButton.extended(
              label: const Text('Neue Meldung'),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              onPressed: _newReport,
              tooltip: 'Neue Meldung erstellen',
              elevation: 4.0,
              icon: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
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

  ///For Searching
  _buildLeading() {
    return IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _drawerKey.currentState!.openDrawer());
  }

  _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Suche eingeben...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) {
        queryText = query;
        updateSearchQuery();
      },
    );
  }

  _buildTitle() {
    return const Text(
      'OObacht!',
      style: TextStyle(
          fontFamily: 'Courgette',
          color: Colors.white,
          fontWeight: FontWeight.w900),
      maxLines: 1,
    );
  }

  _buildActions(ThemeData theme) {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
      PopupMenuButton(
          icon: const Icon(Icons.filter_alt),
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                textStyle: TextStyle(color: theme.primaryColor),
                child: const Text("Kategorie Filter"),
              ),
              PopupMenuItem<int>(
                value: 1,
                textStyle: TextStyle(
                    color: showOnlyOwn ? Colors.orange : theme.primaryColor),
                child: const Text("Nur Eigene anzeigen"),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 0) {
              _showCategoryPicker(context, theme);
            } else if (value == 1) {
              //TODO nur Eigene anzeigen absprechen -> backend/frontend-seitig filtern?
              ReportFunctions.oobacht();
              showOnlyOwn = !showOnlyOwn;
            }
          }),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery() {
    List<Report> results = [];
    if (queryText.isEmpty) {
      results = allReports;
    } else {
      results = _getFilteredReports();
    }

    print(results);

    setState(() {
      filteredReports = results;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      queryText = "";
      updateSearchQuery();
    });
  }

  void _showCategoryPicker(BuildContext context, ThemeData theme) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return MultiSelectDialog(
            items: allGroups.map((e) => MultiSelectItem(e, e.name)).toList(),
            initialValue: selectedGroups,
            onConfirm: (values) {
              selectedGroups = values;
              setState(() {
                filteredReports = _getFilteredReports();
              });
            },
            title: Text(
              "Kategorie Filter",
              style: TextStyle(color: theme.primaryColor),
            ),
            backgroundColor: theme.colorScheme.background,
            checkColor: Colors.white,
            selectedColor: Colors.orange,
            unselectedColor: theme.primaryColor,
            itemsTextStyle: TextStyle(color: theme.primaryColor),
            selectedItemsTextStyle: TextStyle(color: theme.primaryColor),
          );
        });
  }

  List<Report> _getFilteredReports() {
    List<Report> reports = allReports;
    if(selectedGroups.isNotEmpty) {
      reports = reports
          .where((report) =>
                report.groups.any((group) =>
                    selectedGroups.map((e) => e.id).contains(group.id)))
                .toList();
    }
    if(queryText.isNotEmpty) {
      reports = reports
          .where((report) =>
                report.title.toLowerCase().contains(queryText.toLowerCase()))
                .toList();
    }
    return reports;
  }

  ///MOCK DATA
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
          "http://", [], RepeatingReportsEnum.none),
      Report(
          "2",
          "Richtig langer Name der Meldung was geht denn hier ab??!?!?",
          "Diese Meldung hat kein Bild hinterlegt, darum keine Anzeige oben!",
          DateTime.now(),
          [
            Group("1", "Mathematiker", Icons.add, Colors.blue),
          ],
          const LatLng(48.435166, 8.706739),
          "", ["Cosinus"], RepeatingReportsEnum.hot),
      Report(
          "3",
          "Dritte Meldung, die komplett mit ihrem Titel übers Ziel hinaus schießt und hoffentlich richtig angezeigt wird",
          "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et e",
          DateTime.now(),
          [
            Group("5", "Uhrwerker", Icons.watch, Colors.red),
          ],
          const LatLng(48.445166, 8.716739),
          "http://", ["Rolex", "Gucci", "Prada"], RepeatingReportsEnum.rain),
    ];
  }

  static List<Group> _getGroupsMock() {
    return [
      Group("1", "Mathematiker", Icons.add, Colors.blue),
      Group("2", "Speicherwütiger!", Icons.save, Colors.green),
      Group("3", "Was auch immer?!", Icons.person, Colors.blueGrey),
      Group("4", "Gute Frage", Icons.ten_k, Colors.yellow),
      Group("5", "Uhrwerker", Icons.watch, Colors.red),
    ];
  }
}
