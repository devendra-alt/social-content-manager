import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share/share.dart';

class Person {
  final String name;
  final String address;
  final String message;
  final DateTime dateOfDeath;
  final String imagePath;

  Person({
    required this.name,
    required this.address,
    required this.message,
    required this.dateOfDeath,
    required this.imagePath,
  });
}

// Your Create class remains the same, and now we create a new DisplayPerson class.
class DisplayPerson extends StatelessWidget {
  final Person person;

  const DisplayPerson({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Image.file(
                      File(person.imagePath), // Replace this with your image URL
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    // Frame around the image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.deepOrangeAccent,
                            width: 2
                          )
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${person.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${person.address}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Date of Death: ${person.dateOfDeath.toString()}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Message: ${person.message}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: () {
                    // Perform like action
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    String text = 'Name: ${person.name}\n'
                        'Address: ${person.address}\n'
                        'Message: ${person.message}';
                    Share.shareFiles([person.imagePath],text:text);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    // Perform bookmark action
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Comments:',
              style: TextStyle(fontSize: 18),
            ),
            // Add your comment section UI here, e.g., a ListView for comments.
          ],
        ),
      ),
    );
  }
}
