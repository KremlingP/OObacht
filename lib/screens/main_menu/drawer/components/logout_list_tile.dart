import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutListTile extends StatelessWidget {
  const LogoutListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
      title: Text(
        "Abmelden",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onTap: () async {
        await GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
      },
    );
  }
}
