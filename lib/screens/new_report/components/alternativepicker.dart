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
    return Column(
      children: [
        TextFormField(
          controller: _alternativeController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          maxLength: 200,
          autocorrect: true,
          onFieldSubmitted: (value) => {
            setState(() {
              if (value.trim().isNotEmpty) {
                alternatives.add(value.trim());
                NewReportScreen.of(context)?.alternatives = alternatives;
                _alternativeController.clear();
              }
            })
          },
          decoration: InputDecoration(
            labelText: 'Alternative eingeben',
            hintText: 'Füge eine Alternative hinzu...',
            border: const OutlineInputBorder(),
            labelStyle: TextStyle(color: theme.primaryColor),
            hintStyle: TextStyle(color: theme.primaryColor.withOpacity(0.5)),
          ),
          style: TextStyle(color: theme.primaryColor),
        ),
        alternatives.isNotEmpty
            ? SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: alternatives.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(alternatives[index]),
                      onDismissed: (direction) {
                        setState(() {
                          alternatives.removeAt(index);
                          NewReportScreen.of(context)?.alternatives =
                              alternatives;
                        });
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.primaryColor,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(alternatives[index],
                            style: TextStyle(color: theme.primaryColor)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          color: theme.primaryColor,
                          onPressed: () {
                            setState(() {
                              alternatives.removeAt(index);
                              NewReportScreen.of(context)?.alternatives =
                                  alternatives;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }
}
