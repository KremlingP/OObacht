import 'package:flutter/material.dart';
import 'package:oobacht/firebase/functions/group_functions.dart';

import '../logic/classes/group.dart';
import '../screens/new_report/new_report_screen.dart';

class CategoryPicker extends StatefulWidget {
  final String superScreen;
  final List<Group> categories;
  List<Group> selectedCategories;

  CategoryPicker(
      {Key? key,
      required this.superScreen,
      required this.categories,
      required this.selectedCategories})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  final _multiSelectKey = GlobalKey<FormFieldState>();

  final TextEditingController _searchQueryController = TextEditingController();
  String queryText = "";
  bool _isSearching = false;
  List<Group> shownCategories = [];

  @override
  void initState() {
    shownCategories = widget.categories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double shortestViewportWidth = MediaQuery.of(context).size.shortestSide;

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Button to open the bottom sheet
          ElevatedButton(
              child: const Text("Kategorien auswählen"),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: theme.colorScheme.background,
                  enableDrag: true,
                  elevation: 0,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    /// StatefulBuilder to rebuild the bottom sheet
                    return StatefulBuilder(builder:
                        (BuildContext context, StateSetter setModalState) {
                      /// Padding to make the bottom sheet move with the keyboard
                      return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SizedBox(
                              height: shortestViewportWidth * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /// Search bar
                                  SizedBox(
                                    height: shortestViewportWidth * 0.15,
                                    width: double.infinity,
                                    child: Container(
                                        color: theme.colorScheme.primary,
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            _isSearching
                                                ?

                                                /// Search bar
                                                SizedBox(
                                                    width: 200,
                                                    child: TextField(
                                                      controller:
                                                          _searchQueryController,
                                                      autofocus: true,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Suchen...",
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: TextStyle(
                                                            color: theme
                                                                .primaryColor),
                                                      ),
                                                      cursorColor:
                                                          theme.primaryColor,
                                                      style: TextStyle(
                                                          color: theme
                                                              .primaryColor,
                                                          fontSize: 16.0),
                                                      onChanged: (query) {
                                                        queryText = query;
                                                        shownCategories = widget
                                                            .categories
                                                            .where((element) => element
                                                                .name
                                                                .toLowerCase()
                                                                .contains(queryText
                                                                    .toLowerCase()))
                                                            .toList();
                                                        setModalState(() {});
                                                      },
                                                    ))
                                                :

                                                /// Title
                                                Text(
                                                    'Kategorien',
                                                    style: TextStyle(
                                                        color:
                                                            theme.primaryColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 20.0),
                                                    maxLines: 1,
                                                  ),
                                            const Spacer(),
                                            _isSearching
                                                ?

                                                /// Close search button
                                                IconButton(
                                                    icon:
                                                        const Icon(Icons.clear),
                                                    onPressed: () {
                                                      setModalState(() {
                                                        _searchQueryController
                                                            .clear();
                                                        queryText = "";
                                                        shownCategories = widget
                                                            .categories
                                                            .where((element) => element
                                                                .name
                                                                .toLowerCase()
                                                                .contains(queryText
                                                                    .toLowerCase()))
                                                            .toList();
                                                        setModalState(() {
                                                          _isSearching = false;
                                                        });
                                                      });
                                                    },
                                                  )
                                                :

                                                /// Search button
                                                IconButton(
                                                    icon: const Icon(
                                                        Icons.search),
                                                    onPressed: () {
                                                      setModalState(() {
                                                        _isSearching = true;
                                                      });
                                                    },
                                                  )
                                          ],
                                        )),
                                  ),

                                  /// All available categories as chips
                                  SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: -6.0,
                                      alignment: WrapAlignment.start,
                                      direction: Axis.horizontal,
                                      children: shownCategories
                                          .map(
                                            (group) => ActionChip(
                                              label: Text(
                                                group.name,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              backgroundColor: widget
                                                      .selectedCategories
                                                      .where((element) =>
                                                          element.id ==
                                                          group.id)
                                                      .isNotEmpty
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme.primary
                                                      .withOpacity(0.4),
                                              avatar: CircleAvatar(
                                                  backgroundColor: widget
                                                          .selectedCategories
                                                          .where((element) =>
                                                              element.id ==
                                                              group.id)
                                                          .isNotEmpty
                                                      ? theme
                                                          .colorScheme.primary
                                                      : theme
                                                          .colorScheme.primary
                                                          .withOpacity(0.4),
                                                  child: ImageIcon(group.icon,
                                                      color: Colors.white)),
                                              onPressed: () {
                                                setState(() {
                                                  if (widget.selectedCategories
                                                      .where((element) =>
                                                          element.id ==
                                                          group.id)
                                                      .isNotEmpty) {
                                                    widget.selectedCategories
                                                        .remove(widget
                                                            .selectedCategories
                                                            .where((element) =>
                                                                element.id ==
                                                                group.id)
                                                            .first);
                                                    if (widget.superScreen ==
                                                        "profile") {
                                                      GroupFunctions
                                                          .unsubscribeGroup(
                                                              group);
                                                    }
                                                  } else {
                                                    widget.selectedCategories
                                                        .add(group);
                                                    if (widget.superScreen ==
                                                        "profile") {
                                                      GroupFunctions
                                                          .subscribeGroup(
                                                              group);
                                                    }
                                                  }
                                                  if (widget.superScreen ==
                                                      "newReport") {
                                                    NewReportScreen.of(context)
                                                            ?.selectedCategories =
                                                        widget
                                                            .selectedCategories;
                                                  } else if (widget
                                                          .superScreen ==
                                                      "profile") {
                                                  } else {
                                                    throw Exception(
                                                        "Unknown superScreen: ${widget.superScreen}");
                                                  }
                                                });
                                                setModalState(() {});
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  const Spacer(),

                                  /// Button to close the bottom sheet
                                  SizedBox(
                                      height: shortestViewportWidth * 0.1,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              _isSearching = false;
                                            });
                                          },
                                          child: const Text("Fertig"))),
                                ],
                              )));
                    });
                  },
                );
              }),
          const SizedBox(height: 5.0),

          /// Chips to show selected items
          Wrap(
            spacing: 8.0,
            runSpacing: -6.0,
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: widget.selectedCategories
                .map(
                  (group) => ActionChip(
                    label: Text(
                      group.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: group.color,
                    avatar: CircleAvatar(
                      backgroundColor: group.color,
                      child: ImageIcon(group.icon, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        if (widget.selectedCategories
                            .where((element) => element.id == group.id)
                            .isNotEmpty) {
                          widget.selectedCategories.remove(widget
                              .selectedCategories
                              .where((element) => element.id == group.id)
                              .first);
                        }
                        if (widget.superScreen == "newReport") {
                          NewReportScreen.of(context)?.selectedCategories =
                              widget.selectedCategories;
                        } else if (widget.superScreen == "profile") {
                          GroupFunctions.unsubscribeGroup(group);
                        } else {
                          throw Exception(
                              "Unknown superScreen: ${widget.superScreen}");
                        }
                      });
                    },
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
