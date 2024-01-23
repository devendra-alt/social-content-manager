import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rtcTokenGeneratorRepository = Provider((ref) => RtcTokenService());

class RtcTokenService {
  Future<String> fetchTokenSerice({
    required uid,
    required String channelName,
    required bool isBroadcaster,
  }) async {
    try {
      final dio = Dio();

      String role = isBroadcaster ? 'Broadcaster' : 'Audience';

      String url =
          'https://tkn-genv5.netlify.app/.netlify/functions/api/rtc/$channelName/'
          '$role/uid/${uid.toString()}';

      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.json),
      );

      print("response::${response.data.toString()}");

      if (response.statusCode == 200) {
        Map<String, dynamic> json = response.data;
        String newToken = json['rtcToken'] as String;
        return newToken;
      } else {
        throw Exception('Failed to Fetch');
      }
    } catch (e) {
      print("error::$e");
    }
    return '';
  }
}