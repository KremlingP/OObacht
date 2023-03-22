library kegel_kumpel.navigator;

import 'package:flutter/material.dart';

//Navigates to new screen, needs the new Screen as Widget and the current context to add the new Screen on top
Future navigateToNewScreen(
    {required Widget newScreen, required BuildContext context}) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (c, a1, a2) => newScreen,
      transitionsBuilder: (c, anim, a2, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 250),
    ),
  );
}
