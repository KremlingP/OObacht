import 'package:flutter/material.dart';
import 'package:oobacht/screens/main_menu/main_menu_screen.dart';

import '../../../../utils/navigator_helper.dart' as navigator;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            ),
            onPressed: () {
              navigator.navigateToNewScreen(
                  newScreen: const MainMenuScreen(), context: context);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
