import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  final String text;
  final int maxLines;

  const NormalText({Key? key, required this.text, required this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AutoSizeText(
      text,
      maxLines: maxLines,
      style: TextStyle(color: theme.primaryColor),
    );
  }
}
