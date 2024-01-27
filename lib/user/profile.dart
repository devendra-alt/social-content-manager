import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/public/login.dart';
import 'package:social_content_manager/service/auth/Secure.dart';
import 'package:social_content_manager/service/auth/controller/auth_controller.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  String _imageUrl = 'https://via.placeholder.com/150';

  void changePassword() {
    print('Password changed!');
  }

  void logout() async {
    deleteFromSecureStorage("token");
    deleteFromSecureStorage('id');
    deleteFromSecureStorage('username');
    deleteFromSecureStorage('email');
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userState = ref.watch(authControllerProvider);
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
                  userState.username,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  userState.email,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangePasswordScreen(changePassword),
                      ),
                    );
                  },
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        );
      },
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
