import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:oobacht/firebase/functions/group_functions.dart';
import 'package:oobacht/logic/services/pushnotificationsservice.dart';
import 'package:oobacht/main.dart';
import 'package:oobacht/screens/main_menu/pages/main_list/main_list.dart';
import 'package:oobacht/screens/new_report/new_report_screen.dart';
import 'package:oobacht/widgets/ErrorTextWithIcon.dart';
import 'package:oobacht/widgets/error_text.dart';
import 'package:oobacht/widgets/loading_hint.dart';

import '../../../../utils/navigator_helper.dart' as navigator;
import '../../firebase/functions/report_functions.dart';
import '../../logic/classes/group.dart';
import '../../logic/classes/report.dart';
import '../../widgets/map/map_widget.dart';
import 'drawer/main_menu_drawer.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  late Future<List<Report>> filteredReports;
  bool _isCurrentlyUpdating = false;

  //PageController to make pages swipeable
  final _pageViewController = PageController();
  int _activePageIndex = 0;

  //for search bar and filtering
  final TextEditingController _searchQueryController = TextEditingController();
  String queryText = "";
  bool _isSearching = false;
  late Future<List<Group>> allGroups;
  List<Group> selectedGroups = [];
  bool showOnlyOwn = false;

  @override
  void initState() {
    filteredReports = ReportFunctions.getAllReports();
    allGroups = GroupFunctions.getAllGroups();

    // Send initial position and fcm token
    startPositionListener();
    PushNotificationService.sendSavedFcmTokenToServer();

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
      onDrawerChanged: (wasOpened) => {
        if (!wasOpened) {updateFilteredReports()}
      },
      body: SafeArea(
          child: Stack(
        children: [
          FutureBuilder(
            future: filteredReports,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return const ErrorTextWithIcon(
                    text:
                        "Fehler beim Laden der Meldungen! \n Bitte Verbindung überprüfen!",
                    icon: Icons.wifi_off);
              }
              if (snapshot.hasData) {
                return PageView(
                  controller: _pageViewController,
                  children: [
                    MapWidget(
                      reports: snapshot.data,
                      showMarkerDetails: true,
                      showMapCaption: true,
                    ),
                    MainList(
                        reports: snapshot.data,
                        refreshMethod: updateFilteredReports),
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      updateFilteredReports();
                      _activePageIndex = index;
                    });
                  },
                );
              } else {
                return const Center(
                    child: LoadingHint(text: "Lade Meldungen..."));
              }
            },
          ),
          _isCurrentlyUpdating
              ? Container(
                  color: Colors.black54,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo_animated.gif',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        "Aktualisiere Meldungen...",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )))
              : Container(),
        ],
      )),
      floatingActionButton: FutureBuilder(
        future: allGroups,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: const Text('Neue Meldung'),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              onPressed: () => _newReport(snapshot.data),
              tooltip: 'Neue Meldung erstellen',
              elevation: 4.0,
              icon: const Icon(Icons.add),
            );
          }
          return Container();
        },
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

  void _newReport(List<Group> groups) async {
    navigator
        .navigateToNewScreen(
            newScreen: NewReportScreen(
              reports: filteredReports,
              categories: groups,
            ),
            context: context)
        .then((value) {
      updateFilteredReports();
    });
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
        setState(() {
          queryText = query;
          updateFilteredReports();
        });
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
              setState(() {
                showOnlyOwn = !showOnlyOwn;
                updateFilteredReports();
              });
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
      updateFilteredReports();
    });
  }

  void _showCategoryPicker(BuildContext context, ThemeData theme) {
    showDialog(
        context: context,
        builder: (ctx) {
          return FutureBuilder(
              future: allGroups,
              builder: (context, AsyncSnapshot<List<Group>> snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Container(
                        child: const ErrorText(
                            text:
                                "Es ist ein Fehler aufgetreten! Drücken Sie \"Zurück\"!")),
                  );
                }
                if (snapshot.hasData) {
                  return MultiSelectDialog(
                    items: snapshot.data!
                        .map((g) => MultiSelectItem(g, g.name))
                        .toList(),
                    initialValue: selectedGroups,
                    onConfirm: (values) {
                      selectedGroups = values;
                      setState(() {
                        updateFilteredReports();
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
                    selectedItemsTextStyle:
                        TextStyle(color: theme.primaryColor),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  );
                }
              });
        });
  }

  Future<List<Report>> _getFilteredReports() async {
    _isCurrentlyUpdating = true;
    List<Report> reports = showOnlyOwn
        ? await ReportFunctions.getOwnReports()
        : await ReportFunctions.getAllReports();

    if (selectedGroups.isNotEmpty) {
      reports = reports
          .where((report) => report.groups.any(
              (group) => selectedGroups.map((e) => e.id).contains(group.id)))
          .toList();
    }
    if (queryText.isNotEmpty) {
      reports = reports
          .where((report) =>
              report.title.toLowerCase().contains(queryText.toLowerCase()))
          .toList();
    }
    setState(() {
      _isCurrentlyUpdating = false;
    });
    return reports;
  }

  void updateFilteredReports() {
    setState(() {
      filteredReports = _getFilteredReports();
    });
  }
}
