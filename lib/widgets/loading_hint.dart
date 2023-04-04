import 'package:flutter/material.dart';

class LoadingHint extends StatelessWidget {
  final String text;

  const LoadingHint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          text,
          style: TextStyle(color: theme.primaryColor),
        )
      ],
    );
  }
}
