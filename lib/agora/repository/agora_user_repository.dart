import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/ag_credentials.dart';
import 'package:dio/dio.dart';

final agoraUserRepositoryProvider = Provider<AgoraUserRepository>((ref) {
  return AgoraUserRepository();
});

class AgoraUserRepository {
  final dio = Dio();
  Future<void> createAgoraUser(String username, String password) async {
    String url =
        'https://${AgoraCredentials.host}/${AgoraCredentials.orgName}/${AgoraCredentials.appName}/users';

    try {
      Response response = await dio.post(
        url,
        data: {"username": username, "password": password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${AgoraCredentials.appToken}'
          },
        ),
      );
    } on DioException catch (e) {
   
      if (e.response!.data['error'] == 'duplicate_unique_property_exists') {
        print('correct');
      } else {
        rethrow;
      }
    }
  }
}
