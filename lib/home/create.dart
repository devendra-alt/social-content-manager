import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_content_manager/home/display.dart';

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
  String _address = '';
  String _message = '';

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    if (filePath != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 200,
                        child: Image.file(
                          File(filePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              filePath = result.files.first.path!;
                            });
                          } else {
                            print('No file selected');
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add Image'),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 3,
                onSaved: (value) {
                  _message = value!;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date of Death:',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectedDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form.save();
                    // Process the data or submit the form
                    // For example, you can send the data to an API here
                    // _name, _address, _message, selectedDate, filePath can be used here
                    Navigator.replace(
                      context,
                      oldRoute: ModalRoute.of(context)!,
                      newRoute: MaterialPageRoute(
                        builder: (context) => DisplayPerson(
                          person: Person(
                            name: _name,
                            address: _address,
                            message: _message,
                            dateOfDeath: selectedDate,
                            imagePath: filePath ?? '',
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
