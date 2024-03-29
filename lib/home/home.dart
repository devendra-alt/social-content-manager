import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/screens/ag_create_channel_screen.dart';
import 'package:social_content_manager/agora/screens/live_channels_screen.dart';
import 'package:social_content_manager/home/create.dart';
import 'package:social_content_manager/home/template.dart';
import 'package:social_content_manager/user/profile.dart';
import 'package:social_content_manager/utils/card.dart';

// Assuming you have a list of deceased individuals with their details
class DeceasedPerson {
  final String name;
  final String imageUrl;

  DeceasedPerson({required this.name, required this.imageUrl});
}

final List<DeceasedPerson> deceasedList = [
  DeceasedPerson(name: 'User', imageUrl: 'assets/db1.jpg'),
  DeceasedPerson(name: 'User', imageUrl: 'assets/db1.jpg'),
  DeceasedPerson(name: 'User', imageUrl: 'assets/db1.jpg'),
  DeceasedPerson(name: 'User', imageUrl: 'assets/db1.jpg'),
  DeceasedPerson(name: 'User', imageUrl: 'assets/db1.jpg'),
  DeceasedPerson(name: 'User', imageUrl: 'assets/db1.jpg'),
  // Add more individuals here
];

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'hello! User'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage()))
                  },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        padding: EdgeInsets.only(left: 16),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('CREATE TEMPLET',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                            SizedBox(height: 20),
                            Text('create our custom templet'),
                            SizedBox(height: 20),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Create(title: 'Add content'),
                                  ),
                                );
                              },
                              child: Icon(Icons.arrow_right_alt),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 20, height: 20),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                SizedBox(width: 20, height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 20, height: 20),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(' Your Templates'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: deceasedList.length,
                itemBuilder: (BuildContext context, int index) {
                  final DeceasedPerson person = deceasedList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Template()));
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.asset(person.imageUrl),
                          ),
                          SizedBox(height: 8),
                          Text(
                            person.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AgoraScreen()));
                    },
                    child: Row(
                      children: const [Text("Live"), Icon(Icons.arrow_right)],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RenderDeceasedList()));
                    },
                    child: Row(
                      children: const [Text("People"), Icon(Icons.arrow_right)],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LiveChannelsScreen(),
                  ),
                );
              },
              child: Text('Ongoing streams'),
            ),
            SizedBox(height: 20),
           // ElevatedButton(
           //   onPressed: () {
           //     Navigator.of(context).push(
           //       MaterialPageRoute(
           //         builder: (_) => MyHome()
           //       ),
           //     );
           //   },
           //   child: Text('Chat'),
           // ),
          ],
        ),
      ),
    );
  }
}
