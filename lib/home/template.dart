import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
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
              child: Container(
                width: 200, // Assuming square frame
                height: 200, // Assuming square frame
                color: Colors.grey, // Replace with your image
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add functionality for left button
                },
                child: Text('Left Button'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add functionality for right button
                },
                child: Text('Right Button'),
              ),
            ],
          ),
          Expanded(
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
                        'Full Name: John Doe',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text('Date of Death: January 1, 2023'),
                      SizedBox(height: 10),
                      Text('Address: 123 Main St, City, Country'),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        // Add functionality to handle the message
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Comments',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: const [
                            // Comment list items will go here
                            ListTile(
                              title: Text('Comment 1'),
                              subtitle: Text('Comment 1 details'),
                              // Add functionality for likes and replies
                            ),
                            ListTile(
                              title: Text('Comment 2'),
                              subtitle: Text('Comment 2 details'),
                              // Add functionality for likes and replies
                            ),
                          ],
                        ),
                      ),
                    ],
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
