import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:oobacht/utils/auth_wrapper.dart';

import '../../../../logic/classes/group.dart';
import '../../../../utils/navigator_helper.dart';
import '../../../../widgets/categorypicker.dart';
import '../components/drawer_page_app_bar.dart';

class ProfileDrawerPage extends StatefulWidget {
  const ProfileDrawerPage({Key? key}) : super(key: key);

  @override
  _ProfileDrawerPageState createState() => _ProfileDrawerPageState();

  static _ProfileDrawerPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ProfileDrawerPageState>();
}

class _ProfileDrawerPageState extends State<ProfileDrawerPage> {
  // TODO get radius from backend
  int _currentRadius = 1;

  List<Object?> selectedCategories = [];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: const DrawerPageAppBar(
        title: "Profil",
      ),
      body: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                    "Umkreis setzen",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: theme.primaryColor,
                    )
                ),
                const SizedBox(height: 10),
                Text(
                    "Du erhältst für Gefahren im Radius von $_currentRadius km Benachrichtigungen.",
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                NumberPicker(
                  value: _currentRadius,
                  minValue: 1,
                  maxValue: 100,
                  step: 1,
                  haptics: true,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: theme.primaryColor,
                  ),
                  selectedTextStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  onChanged: (value) => {
                    setState(() => _currentRadius = value)
                    // TODO send radius to backend
                  },
                ),
                const SizedBox(height: 100),
                Text(
                    "Interessensgebiete setzen",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: theme.primaryColor,
                    )
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: const CategoryPicker(superScreen: "profile",),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Interessensgebiete wurden gespeichert!')));
                        var categories = selectedCategories.map((e) => e as Group).toList();
                        // TODO: Save categories to database
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bitte mindestens eine Kategorie auswählen.')));
                      }
                    },
                    child: const Text('Speichern')
                ),
                const SizedBox(height: 100),
                Text(
                    "Account und zugehörige Daten löschen",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: theme.primaryColor,
                    )
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO delete account
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account wird gelöscht...')));
                    navigateToNewScreen(newScreen: const AuthWrapper(), context: context);
                  },
                  child: Text("Account löschen"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
