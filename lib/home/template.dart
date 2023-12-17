import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';

class Template extends StatefulWidget {
  const Template({Key? key}) : super(key: key);

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  bool showComments = false;

  late String name;
  late String dateOfDeath;
  late String address;
  late String message;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    name = 'John Doe';
    dateOfDeath = 'January 1, 2023';
    address = '123 Main St, City, Country';
    message =
        'In loving memory, your absence weighs heavy upon our hearts. Each passing day echoes with the void you\'ve left behind.';
    imagePath = 'assets/db1.jpg'; // Replace with your image asset path
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200, // Adjust height as needed
            child: Center(
              child: Image.asset(
                'assets/db1.jpg', // Replace with your image asset path
                width: 200, // Set your desired width
                height: 200, // Set your desired height
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  // Add functionality for left button
                },
                child: SvgPicture.asset(
                  'assets/kalash.svg', // Replace with your left arrow icon asset path
                  width: 32, // Set your desired width
                  height: 32, // Set your desired height
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  String text = 'Name: $name\n'
                      'Date of Death: $dateOfDeath\n'
                      'Address: $address\n'
                      'Message: $message';
                  Share.shareFiles([imagePath], text: text);
                },
                child: Icon(Icons.share), // Right button as a share icon
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('Date of Death: January 1, 2023'),
                        SizedBox(height: 10),
                        Text('Address: 123 Main St, City, Country'),
                        SizedBox(height: 10),
                        Text(
                          'Message',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'In loving memory, your absence weighs heavy upon our hearts. Each passing day echoes with the void you\'ve left behind.',
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showComments = !showComments;
                            });
                          },
                          child: Text(
                            showComments ? 'Hide Comments' : 'Show Comments',
                          ),
                        ),
                        SizedBox(height: 10),
                        if (showComments)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 10, // Assuming at least 10 comments
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('Comment ${index + 1}'),
                                subtitle: Text('Comment ${index + 1} details'),
                                // Add functionality for likes and replies
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
