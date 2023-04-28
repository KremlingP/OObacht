import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  final String title;
  final Widget child;
  const InputComponent({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            )),
        child
      ],
    );
  }
}
