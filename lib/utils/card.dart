import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_content_manager/home/template.dart'; // Import for using SVG

class DeceasedPerson {
  final String name;
  final String dateOfDeath;
  int likes;

  DeceasedPerson({
    required this.name,
    required this.dateOfDeath,
    this.likes = 0,
  });
}

class RenderDeceasedList extends StatefulWidget {
  @override
  _RenderDeceasedListState createState() => _RenderDeceasedListState();
}

class _RenderDeceasedListState extends State<RenderDeceasedList> {
  final List<DeceasedPerson> deceasedList = [
    DeceasedPerson(name: 'User 1', dateOfDeath: 'March 5, 2022'),
    DeceasedPerson(name: 'User 2', dateOfDeath: 'January 20, 2023'),
    DeceasedPerson(name: 'User 3', dateOfDeath: 'January 20, 2023'),
    DeceasedPerson(name: 'User 4', dateOfDeath: 'January 20, 2023'),
    DeceasedPerson(name: 'User 5', dateOfDeath: 'January 20, 2023'),
    DeceasedPerson(name: 'User 6', dateOfDeath: 'January 20, 2023'),
    DeceasedPerson(
        name: 'User 7',
        dateOfDeath: 'January 20, 2023') // Add more deceased individuals here
  ];

  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getMoreData();
    }
  }

  void _getMoreData() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      // Simulating fetching more data, you can fetch actual data here
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          for (int i = 0; i < 5; i++) {
            deceasedList.add(DeceasedPerson(
                name: 'New Person $i', dateOfDeath: 'Some Date'));
          }
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deceased Persons'),
      ),
      body: ListView.builder(
        itemCount: deceasedList.length + 1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if (index == deceasedList.length) {
            return _buildProgressIndicator();
          } else {
            return _buildDeceasedCard(deceasedList[index]);
          }
        },
      ),
    );
  }

  Widget _buildDeceasedCard(DeceasedPerson person) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Template()));
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/db1.jpg'),
                // Replace with your image asset
              ),
              title: Text(person.name),
              subtitle: Text('Date of Death: ${person.dateOfDeath}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        person.likes++; // Increase the likes count
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/kalash.svg', // Replace with your SVG icon path
                      height: 30, // Set your desired height
                      width: 30, // Set your desired width
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Implement share functionality
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('${person.likes} Likes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
