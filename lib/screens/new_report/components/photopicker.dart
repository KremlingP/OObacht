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
    return Container(
        child: imageFile == null
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          imageFromGallery();
                        },
                        icon: const Icon(Icons.photo, color: Colors.white),
                        label: const Text("Foto auswählen",
                            maxLines: 1, style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          imageFromCamera();
                        },
                        icon:
                            const Icon(Icons.photo_camera, color: Colors.white),
                        label: const Text("Foto aufnehmen",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: theme.colorScheme.primary, width: 3.0)),
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
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  )
                ],
              )));
  }

  imageFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        NewReportScreen.of(context)?.imageFile = imageFile!;
      });
    }
  }

  imageFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        NewReportScreen.of(context)?.imageFile = imageFile!;
      });
    }
  }
}
