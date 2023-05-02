import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase/firebase_options.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    MediaQueryData data = MediaQuery.of(context);
    return Container(
      color: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/logo.png',
            height: data.size.shortestSide / 5,
            width: data.size.shortestSide / 1.4,
            color: Colors.white,
          ),
          SignInButton(
            Buttons.Google,
            text: "Mit Google fortfahren",
            onPressed: () async {
              dynamic result = await signInWithGoogle();
              if (result == null) {
                print('error signing in');
              } else {
                print('signed in: ${result.name}');
              }
            },
          )
        ],
      ),
    );
  }

  Future signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId).signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      return userCredential;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
