import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(BuildContext context,
      IconData iconData, String title, String body) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Row(
              children: [
                Icon(iconData, color: Theme.of(context).primaryColor),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Text(
              body,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            actions: <Widget>[
              OutlinedButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () =>
                      Navigator.of(context).pop(DialogAction.abort),
                  child: Text("Nein")),
              OutlinedButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.green),
                  onPressed: () => Navigator.of(context).pop(DialogAction.yes),
                  child: Text("Ja")),
            ],
          );
        });
    return (action != null) ? action : DialogAction.abort;
  }
}
