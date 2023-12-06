import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
class Create extends StatefulWidget {
  const Create({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String? filePath; // Store the file path

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Card(
                  child:SizedBox(
                  width: MediaQuery.of(context).size.width*0.45,
                  height: 200,
                  child: filePath != null ? // Display the image if filePath is not null
                   Image(image: FileImage(
                      filePath != null ? File(filePath!) :
                      File('')
                   ),
                     width: MediaQuery.of(context).size.width * 0.4,
                     height: MediaQuery.of(context).size.height * 0.4,
                   ):
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            filePath = result.files.first.path; // Store the file path
                          });
                        } else {
                          print('No file selected');
                        }
                      },
                      child: Icon(Icons.add),
                    ),
                  )
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
