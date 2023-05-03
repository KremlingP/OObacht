import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oobacht/firebase/functions/group_functions.dart';
import 'package:oobacht/firebase/functions/user_functions.dart';
import 'package:oobacht/utils/auth_wrapper.dart';
import 'package:oobacht/utils/dialoges.dart';

import '../../../../logic/classes/group.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../widgets/ErrorTextWithIcon.dart';
import '../../../../widgets/categorypicker.dart';
import '../../../../widgets/loading_hint.dart';
import '../components/drawer_page_app_bar.dart';

class ProfileDrawerPage extends StatefulWidget {
  const ProfileDrawerPage({Key? key}) : super(key: key);

  @override
  _ProfileDrawerPageState createState() => _ProfileDrawerPageState();

  static _ProfileDrawerPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ProfileDrawerPageState>();
}

class _ProfileDrawerPageState extends State<ProfileDrawerPage> {
  late Future<int> currentRadius;
  late Future<List<Object?>> preselectedCategories;
  late List<Object?> selectedCategories;
  late Future<List<Group>> categories;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    currentRadius = UserFunctions.getRadius();
    preselectedCategories = GroupFunctions.getOwnGroups();
    categories = GroupFunctions.getAllGroups();
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
                    "Fehler beim Laden der Profildaten (Radius)! \nBitte Verbindung überprüfen!",
                icon: Icons.wifi_off);
          }
          if (radiusSnapshot.hasData) {
            return FutureBuilder(
                future: categories,
                builder: (context, AsyncSnapshot<dynamic> allGroupsSnapshot) {
                  if (allGroupsSnapshot.hasError) {
                    return const ErrorTextWithIcon(
                        text:
                            "Fehler beim Laden der Profildaten (Interessensgebiete)! \nBitte Verbindung überprüfen!",
                        icon: Icons.wifi_off);
                  }
                  if (allGroupsSnapshot.hasData) {
                    return FutureBuilder(
                      future: preselectedCategories,
                      builder:
                          (context, AsyncSnapshot<dynamic> ownGroupsSnapshot) {
                        if (ownGroupsSnapshot.hasError) {
                          return const ErrorTextWithIcon(
                              text:
                                  "Fehler beim Laden der Profildaten (Eigene Interessensgebiete)! \nBitte Verbindung überprüfen!",
                              icon: Icons.wifi_off);
                        }
                        if (ownGroupsSnapshot.hasData) {
                          selectedCategories = ownGroupsSnapshot.data;
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Chip(
                                  backgroundColor: theme.colorScheme.secondary,
                                  avatar: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person,
                                        color: Colors.black),
                                  ),
                                  label: Column(
                                    children: [
                                      Text(
                                        FirebaseAuth.instance.currentUser!.displayName!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        FirebaseAuth.instance.currentUser!.email!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
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
                                    await UserFunctions.updateRadius(
                                        value.round()),
                                    setState(() => {
                                          currentRadius =
                                              UserFunctions.getRadius()
                                        })
                                  },
                                  onChanged: (value) => setState(() => {
                                        currentRadius =
                                            Future.value(value.round())
                                      }),
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
                                    categories: allGroupsSnapshot.data,
                                    selectedCategories: ownGroupsSnapshot.data,
                                  ),
                                ),
                                const SizedBox(height: 100),
                                Text("Account und zugehörige Daten löschen",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: theme.primaryColor,
                                    )),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red)),
                                  onPressed: () => _deleteUser(),
                                  child: const Text("Account löschen",
                                      style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                              child: LoadingHint(text: "Lade Profildaten..."));
                        }
                      },
                    );
                  } else {
                    return const Center(
                        child: LoadingHint(text: "Lade Profildaten..."));
                  }
                });
          } else {
            return const Center(
                child: LoadingHint(text: "Lade Profildaten..."));
          }
        },
      )),
    );
  }

  _deleteUser() async {
    final action = await Dialogs.yesAbortDialog(
        context,
        Icons.person_off,
        "Account löschen?",
        "Wollen Sie Ihren Account und Ihre persönlichen Daten wirklich unwiderruflich löschen?\nEine Löschung kann nicht rückgängig gemacht werden!");
    if (action == DialogAction.yes) {
      UserFunctions.deleteUser();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account wird gelöscht...')));
      await GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
      navigateToNewScreen(newScreen: const AuthWrapper(), context: context);
    }
  }
}
