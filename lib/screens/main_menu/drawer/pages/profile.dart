import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oobacht/firebase/functions/group_functions.dart';
import 'package:oobacht/firebase/functions/user_functions.dart';
import 'package:oobacht/utils/auth_wrapper.dart';

import '../../../../logic/classes/group.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../widgets/ErrorTextWithIcon.dart';
import '../../../../widgets/categorypicker.dart';
import '../../../../widgets/loading_hint.dart';
import '../components/drawer_page_app_bar.dart';

class ProfileDrawerPage extends StatefulWidget {
  const ProfileDrawerPage({Key? key, required this.categories})
      : super(key: key);

  final List<Group> categories;

  @override
  _ProfileDrawerPageState createState() => _ProfileDrawerPageState();

  static _ProfileDrawerPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ProfileDrawerPageState>();
}

class _ProfileDrawerPageState extends State<ProfileDrawerPage> {
  late Future<int> currentRadius;

  List<Object?> selectedCategories = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentRadius = UserFunctions.getRadius();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const DrawerPageAppBar(
        title: "Profil",
      ),
      body: SafeArea(
          child: FutureBuilder(
            future: currentRadius,
            builder: (context, AsyncSnapshot<dynamic> radiusSnapshot) {
              if (radiusSnapshot.hasError) {
                return const ErrorTextWithIcon(
                    text:
                        "Fehler beim Laden der Profildaten (Radius)! \n Bitte Verbindung überprüfen!",
                    icon: Icons.wifi_off);
              }
              if (radiusSnapshot.hasData) {
                return FutureBuilder(
                  future: GroupFunctions.getOwnGroups(),
                  builder: (context, AsyncSnapshot<dynamic> groupSnapshot) {
                    if (groupSnapshot.hasError) {
                      return const ErrorTextWithIcon(
                          text:
                              "Fehler beim Laden der Profildaten (Interessensgebiete)! \n Bitte Verbindung überprüfen!",
                          icon: Icons.wifi_off);
                    }
                    if (groupSnapshot.hasData) {
                      return Scaffold(
                        resizeToAvoidBottomInset: false,
                        backgroundColor: theme.colorScheme.background,
                        body: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Text("Umkreis setzen",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: theme.primaryColor,
                                  )),
                              const SizedBox(height: 10),
                              Text(
                                "Du erhältst für Gefahren im Radius von ${radiusSnapshot.data.toStringAsFixed(0)} km Benachrichtigungen.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: theme.primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Slider(
                                value: radiusSnapshot.data.toDouble(),
                                min: 1.0,
                                max: 100.0,
                                onChangeEnd: (value) async => {
                                  await UserFunctions.updateRadius(value.round()),
                                  setState(() =>
                                      {currentRadius = UserFunctions.getRadius()})
                                },
                                onChanged: (value) => setState(() =>
                                    {currentRadius = Future.value(value.round())}),
                              ),
                              const SizedBox(height: 100),
                              Text("Interessensgebiete setzen",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: theme.primaryColor,
                                  )),
                              const SizedBox(height: 10),
                              Form(
                                key: _formKey,
                                child: CategoryPicker(
                                  superScreen: "profile",
                                  categories: widget.categories,
                                  selectedCategories: groupSnapshot.data,
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Interessensgebiete wurden gespeichert!')));
                                      var categories = selectedCategories
                                          .map((e) => e as Group)
                                          .toList();
                                      await GroupFunctions.updateGroupPreferences(
                                          categories);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Bitte mindestens eine Kategorie auswählen.')));
                                    }
                                  },
                                  child: const Text('Speichern')),
                              const SizedBox(height: 100),
                              Text("Account und zugehörige Daten löschen",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: theme.primaryColor,
                                  )),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  UserFunctions.deleteUser();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Account wird gelöscht...')));
                                  await GoogleSignIn().signOut();
                                  FirebaseAuth.instance.signOut();
                                  navigateToNewScreen(
                                      newScreen: const AuthWrapper(),
                                      context: context);
                                },
                                child: Text("Account löschen"),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const LoadingHint(text: "Lade Profildaten...");
                    }
                  },
                );
              } else {
                return const LoadingHint(text: "Lade Profildaten...");
              }
            },
          )
      ),
    );
  }
}
