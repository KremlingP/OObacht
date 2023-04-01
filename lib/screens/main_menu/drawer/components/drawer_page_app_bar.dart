import 'package:flutter/material.dart';

class DrawerPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DrawerPageAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Fredoka', color: Colors.white),
        maxLines: 1,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
