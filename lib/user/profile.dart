import 'package:flutter/material.dart';
import 'package:social_content_manager/service/auth/Secure.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _username = 'John Doe';
  String _email = 'example@example.com';
  String _imageUrl = 'https://via.placeholder.com/150';

  void changePassword() {
    print('Password changed!');
  }

  void logout() async {
    final token = await readFromSecureStorage('token');
    print(token);
    print('Logged out!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(_imageUrl),
            ),
            SizedBox(height: 20),
            Text(
              _username,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _email,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(changePassword),
                  ),
                );
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  final Function changePasswordFunction;

  ChangePasswordScreen(this.changePasswordFunction);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate passwords here before changing
                // Check if new password and confirm new password match
                // Implement your password change logic here

                // For now, call the function passed from the profile page
                changePasswordFunction();
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}









