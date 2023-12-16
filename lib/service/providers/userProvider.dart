import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/service/auth/user.dart';

final userProvider = StateNotifierProvider<UserData, User>((ref) => UserData());
