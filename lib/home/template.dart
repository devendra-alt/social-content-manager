import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';

class Template extends StatefulWidget {
  const Template({Key? key}) : super(key: key);

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  late String name;
  late String dateOfDeath;
  late String address;
  late String message;
  late String imagePath;

  TextEditingController commentController = TextEditingController();
  List<String> comments = [
    'Comment 1',
    'Comment 2',
    // Add initial comments as needed
  ];

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

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Use a GlobalKey for the ListView.builder
            GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

            return Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    key: listKey,
                    initialItemCount: comments.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: ListTile(
                          title: Text(comments[index]),
                        ),
                      );
                    },
                  ),
                ),
                Divider(height: 1, color: Colors.grey),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // Add the comment to the list
                          setState(() {
                            comments.add(commentController.text);
                            commentController.clear();
                            // Insert the new comment with animation
                            listKey.currentState?.insertItem(comments.length - 1);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: Image.asset(
                'assets/db1.jpg',
                width: 200,
                height: 200,
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
                  'assets/kalash.svg',
                  width: 32,
                  height: 32,
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
                child: Icon(Icons.share),
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
                        Text('Date of Death: $dateOfDeath'),
                        SizedBox(height: 10),
                        Text('Address: $address'),
                        SizedBox(height: 10),
                        Text(
                          'Message',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          message,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _showCommentsModal();
                          },
                          child: Text('Show Comments'),
                        ),
                        SizedBox(height: 10),
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
