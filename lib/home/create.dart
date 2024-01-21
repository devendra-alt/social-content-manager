import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/home/display.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart' as _dio;
import 'package:social_content_manager/service/auth/Secure.dart';

class Create extends StatefulWidget {
  const Create({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String? filePath; // Store the file path
  int _imageId = 0;

  final _formKey = GlobalKey<FormState>();

  Future<String?> uploadImageToS3(File file) async {
    try {
      if (file == null || !(await file.exists())) {
        print('Selected file does not exist or is empty');
        return null;
      }

      _dio.Dio dio = _dio.Dio();
      String fileName = basename(file.path);

      _dio.FormData formData = _dio.FormData.fromMap({
        'files': await _dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType('application',
              'octet-stream'), // Change the content type accordingly
        ),
      });



      final token = await readFromSecureStorage("token");


      if (token == null || token.isEmpty) {
        print('Token is null or empty');
        return null;
      }

      _dio.Response response = await dio.post(
        'https://eksamaj.in/hphmeelan/api/upload/',
        data: formData,
        options: _dio.Options(
          headers: {
            'content-type': 'multipart/form-data',
            'Access-Control-Allow-Origin': '*', // CORS header
            'Authorization': 'Bearer $token', // Authorization header with token
            // Add any other headers as needed
          },
        ),
      );

      if (response.statusCode == 200) {
        // Assuming the response contains the URL of the uploaded image
        // print(response.data[0]["id"]);
        setState(() {
          _imageId=response.data[0]["id"];
        });
        return response.data['image_url'];
      } else {
        print('Error uploading image');
        return null;
      }
    } on _dio.DioException catch (e) {
      if (e.response != null) {
        print('Error uploading image: ${e.response!.statusCode}');
        print('Error response: ${e.response!.data}');
      } else {
        print('Error uploading image: $e');
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  String _name = '';
  String _address = '';
  String _message = '';


  DateTime selectedDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,

        );
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
                            File? pickedFile = File(result.files.first.path!);
                            if (pickedFile != null) {
                              String? imageUrl =
                                  await uploadImageToS3(pickedFile);
                              if (imageUrl != null) {
                                setState(() {
                                  filePath = imageUrl;
                                });
                              } else {
                                print('Error uploading image');
                              }
                            } else {
                              print('Error picking image');
                            }
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
                onPressed: () async {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form.save();
                    String mutation = '''
                        mutation(\$full_name:String,\$address:String,\$message:String,\$dod:Date,\$imageId:ID){
                        createTemplate(data:{full_name:\$full_name,address:\$address,message:\$message,dod:\$dod,image:\$imageId}){
                          data{
                            id
                            attributes{
                              full_name
                              address
                              dod
                              
                            }
                          }
                        }
                      }
                    ''';

                    print( new DateFormat("yyyy-MM-dd").format(selectedDate));

                    final QueryResult result =
                        await GraphQLProvider.of(context).value.mutate(
                              MutationOptions(
                                document: gql(mutation),
                                variables: {
                                  'name': _name,
                                  'address': _address,
                                  'message': _message,
                                  'dod':   new DateFormat("yyyy-MM-dd").format(selectedDate),
                                  'imageId':_imageId
                                },

                              ),
                            );

                    if (result.hasException) {
                      print(
                          'Error uploading data: ${result.exception.toString()}');
                    } else {
                      print('Data uploaded successfully!');
                      // Handle successful data upload
                    }

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
