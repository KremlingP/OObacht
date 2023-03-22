import 'package:flutter/material.dart';

import '../../../../utils/navigator_helper.dart' as navigator;

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final BuildContext context;
  final Widget site;

  const DrawerListTile(
      {Key? key,
      required this.icon,
      required this.text,
      required this.context,
      required this.site})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        text,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onTap: () {
        navigator.navigateToNewScreen(newScreen: site, context: context);
      },
    );
  }
}
