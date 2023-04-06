import 'package:flutter/material.dart';

import 'error_text.dart';

class ErrorTextWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;

  const ErrorTextWithIcon({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.red,
          size: 100,
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ErrorText(text: text),
        ),
      ],
    );
  }
}
