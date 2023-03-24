import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oobacht/screens/login/login_screen.dart';
import 'package:oobacht/screens/main_menu/main_menu_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either main menu or login screen
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return const LoginScreen();
          } else {
            return const MainMenuScreen();
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
