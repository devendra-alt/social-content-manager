import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rtcTokenGeneratorRepository = Provider((ref) => RtcTokenService());

class RtcTokenService {
  Future<String> fetchTokenSerice({
    required uid,
    required String channelName,
    required bool isBroadcaster,
  }) async {
    try{
    final dio = Dio();

    String role = isBroadcaster ? 'Broadcaster' : 'Audience';

    String url = 'https://10.0.2.2:7894/rtc/$channelName/'
        '$role/uid/${uid.toString()}';

    final response = await dio.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.data);
      String newToken = json['rtcToken'];
      return newToken;
    } else {
      throw Exception('Failed to Fetch');
    }
  }catch(e){
    print("error::$e");
  }
  return '';
  }
}
