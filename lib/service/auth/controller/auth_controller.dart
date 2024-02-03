import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/repository/agora_user_repository.dart';
import 'package:social_content_manager/service/auth/Secure.dart';
import 'package:social_content_manager/service/auth/user.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User>(
  (ref) {
    return AuthController(
      agoraUserRepository: ref.read(agoraUserRepositoryProvider),
    );
  },
);

class AuthController extends StateNotifier<User> {
  final AgoraUserRepository _agoraUserRepository;
  AuthController({
    required AgoraUserRepository agoraUserRepository,
  })  : _agoraUserRepository = agoraUserRepository,
        super(
          User(username: '', email: '', id: 0),
        );

  void loadUser(
      {required String username, required String email, required int uid}) {
    state = state.copyWith(
      email: email,
      username: username,
      id: uid,
    );
  }

  int get userId {
    return state.id;
  }

  String get username {
    return state.username;
  }

  String get email {
    return state.email;
  }

  Future<void> registerAgoraUser(String username, String password) async {
    _agoraUserRepository.createAgoraUser(username, password);
  }

  void loadUserFromLocalStorage() async {
    int id = int.parse(await readFromSecureStorage('id') as String);
    String username = await readFromSecureStorage('username') as String;
    String email = await readFromSecureStorage('email') as String;

    loadUser(
      username: username,
      email: email,
      uid: id,
    );
  }
}
