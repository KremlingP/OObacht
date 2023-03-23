import 'package:flutter/material.dart';
import 'package:oobacht/screens/main_menu/main_menu_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either main menu or login screen
    return const MainMenuScreen();
  }
}
