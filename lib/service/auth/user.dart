import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  String username;
  String email;
  int id;
  User({required this.username, required this.email, required this.id});
}

class UserData extends StateNotifier<User> {
  UserData()
      : super(User(username: "John Doe", email: "JohnDoe@123.com", id: 1));
  void addData(String email, String username, int id) {
    state.email = email;
    state.username = username;
    state.id = id;
  }
}
