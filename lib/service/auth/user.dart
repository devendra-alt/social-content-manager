import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  String username;
  String email;
  int id;
  User({
    required this.username,
    required this.email,
    required this.id,
  });

  User.fromJson(Map<String, dynamic> map)
      : email = map['email'],
        id = map['id'],
        username = map['username'];

  User copyWith({String? username, String? email, int? id}) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }
}
