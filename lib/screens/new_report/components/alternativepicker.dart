import 'package:flutter/material.dart';

import '../new_report_screen.dart';

class AlternativePicker extends StatefulWidget {
  const AlternativePicker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AlternativePickerState();
}

class _AlternativePickerState extends State<AlternativePicker> {
  final TextEditingController _alternativeController = TextEditingController();
  List<String> alternatives = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Center(
            child: Text("Alternativen hinzufügen",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 20,
                )),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _alternativeController,
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: 200,
            autocorrect: true,
            onFieldSubmitted: (value) => {
              setState(() {
                alternatives.add(value ?? "");
                NewReportScreen.of(context)?.alternatives = alternatives;
                _alternativeController.clear();
              })
            },
            decoration: InputDecoration(
              labelText: 'Alternative',
              hintText: 'Füge eine Alternative hinzu...',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: theme.primaryColor),
              hintStyle: TextStyle(color: theme.primaryColor.withOpacity(0.5)),
            ),
            style: TextStyle(color: theme.primaryColor),
          ),
          alternatives.isNotEmpty
              ? SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: alternatives.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(alternatives[index]),
                        onDismissed: (direction) {
                          setState(() {
                            alternatives.removeAt(index);
                            NewReportScreen.of(context)?.alternatives = alternatives;
                          });
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.primaryColor,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(alternatives[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                alternatives.removeAt(index);
                                NewReportScreen.of(context)?.alternatives = alternatives;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text("Keine Alternativen hinzugefügt.",
                      style:
                          TextStyle(color: theme.primaryColor, fontSize: 15))),
        ],
      ),

      /**Scaffold(
          backgroundColor: theme.colorScheme.background,
          body:  alternatives.isNotEmpty
          ? Column(
              children: [
                ListView.builder(
                  itemCount: alternatives.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(alternatives[index]),
                      onDismissed: (direction) {
                        setState(() {
                          alternatives.removeAt(index);
                        });
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.primaryColor,
                          child: Text('${index+1}'),
                        ),
                        title: Text(alternatives[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              alternatives.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(child: Text("Keine Alternativen hinzugefügt."))
        )**/
    );
  }
}
