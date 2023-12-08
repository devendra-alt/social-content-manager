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

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _dod = '';

  DateTime selectedDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: 200,
                    child: filePath != null
                        ? Image(
                            image: FileImage(
                              filePath != null ? File(filePath!) : File(''),
                            ),
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.4,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(allowMultiple: false);
                              if (result != null && result.files.isNotEmpty) {
                                setState(() {
                                  filePath = result.files.first.path;
                                });
                              } else {
                                print('No file selected');
                              }
                            },
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              maximumSize: Size(200, 50), // Set minimum size
                            ),
                          ),
                  ),
                ),
                Card(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: 200,
                      child: Column(
                        children: [
                          Text(
                            'Date of Death', // Display selected date
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => _selectedDate(
                                context), // Call the date picker function
                            child: Text('Select Date'),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
