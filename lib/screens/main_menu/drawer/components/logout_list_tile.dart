import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oobacht/firebase/functions/user_functions.dart';
import 'package:oobacht/utils/dialoges.dart';

import '../../../../firebase/firebase_options.dart';

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
        final action = await Dialogs.yesAbortDialog(context, Icons.logout,
            "Wirklich abmelden?", "Wollen Sie sich wirklich abmelden?");
        if (action == DialogAction.yes) {
          await UserFunctions.updateFcmToken("");
          await GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId).signOut();
          FirebaseAuth.instance.signOut();
        }
      },
    );
  }
}
