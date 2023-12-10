import 'package:flutter/material.dart';
import 'package:social_content_manager/agora/agora.dart';
import 'package:social_content_manager/home/create.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final List<String> items = List.generate(10, (index) => 'Item ${index + 1}');

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            'hello! User'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                                              Create(title: 'Add content')));
                                },
                                child: Icon(Icons.arrow_right_alt))
                          ],
                        ),
                      )
                    ],
                  )),
                  Card(
                    child: GestureDetector(
                        onTap: () {
                          print('hello Gesture');
                        },
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
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 150,
                          height: 150,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.purple,
                          child: Center(
                            child: Text(
                              'Item ${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ));
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AgoraClient(key: Key('Agora Client'))));
                  },
                  child: Icon(Icons.arrow_right))
            ]));
  }
}
