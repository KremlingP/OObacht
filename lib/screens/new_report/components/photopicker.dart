import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oobacht/screens/new_report/new_report_screen.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
        height: 100,
        child: Scaffold(
            backgroundColor: theme.colorScheme.background,
            body: imageFile == null
                ? Column(
                    children: [
                      Center(
                        child: Text("Foto hinzufügen",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 20,
                            )),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  imageFromGallery();
                                },
                                child: const Text("Foto auswählen"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  imageFromCamera();
                                },
                                child: const Text("Foto aufnehmen"),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              imageFile = null;
                            });
                          },
                          child: Icon(Icons.delete,
                              color: theme.colorScheme.onPrimary),
                        ),
                      )
                    ],
                  ))));
  }

  imageFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        NewReportScreen.of(context)?.imageFile = imageFile!;
      });
    }
  }

  imageFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        NewReportScreen.of(context)?.imageFile = imageFile!;
      });
    }
  }
}
