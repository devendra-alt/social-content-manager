import 'package:flutter_riverpod/flutter_riverpod.dart';

class User extends StateNotifier<User> {
  String username;
  String email;
  User({required this.username, required this.email})
      : super(User(email: email, username: username));
}
