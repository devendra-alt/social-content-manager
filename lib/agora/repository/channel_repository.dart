import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/agora/ag_credentials.dart';
import 'package:social_content_manager/agora/channel_response_model.dart';
import 'package:social_content_manager/service/auth/Secure.dart';

final channelRepositiryProvider = Provider((ref) {
  return ChannelRepositiry();
});

final AuthLink authLink = AuthLink(
  getToken: () async {
    final token = await readFromSecureStorage("token");
    if (token != null) {
      return 'bearer $token';
    }
    return token;
  },
);
final GraphQLClient client = GraphQLClient(
  link: authLink.concat(HttpLink('https://eksamaj.in/meelangraphql')),
  cache: GraphQLCache(store: HiveStore()),
);

class ChannelRepositiry {
  static const String _fetchChannelQuery = """
query Query {
  channels {
    data {
         id
      attributes {
        chat_group_id
        channel_name
        user_id
      }
    }
  }
}
""";

  static const String _fetchChannelsTimeStampQuery = """
query TimeStampQuery {
  channelTimestamps{
    data {
      attributes {
        timestamp
      }
    }
  }
}
""";

  static const String _createChannelAndUpdateTimestamp = """
  mutation CreateChannel(\$data: ChannelInput!, \$updateChannelTimestampData2: ChannelTimestampInput!) {
  createChannel(data: \$data) {
    data {
      id
      attributes {
        channel_name
        user_id
        chat_group_id
      }
    }
  }
  updateChannelTimestamp(id:3  , data: \$updateChannelTimestampData2) {
    data {
      attributes {
        timestamp
      }
    }
  }
}
""";

  static const String _deleteChannelAndUpdateTimestamp = """
mutation DeleteChannelAndUpdateTimestamp(\$channelId:ID!,\$updatetimestamp:ChannelTimestampInput!){
deleteChannel(id:\$channelId){
  data{
    attributes{

    }
  }
}
updateChannelTimestamp(id:3,data:\$updatetimestamp){
  
  data{
    attributes{
      timestamp
    }
  }
}
}

""";

  GraphQLClient get getclient {
    return client;
  }

  Future<List<ChannelResponseModel>> fetchOngoingChannels() async {
    List<ChannelResponseModel> channles = [];
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(_fetchChannelQuery),
        ),
      );
      final length = result.data!['channels']['data'].length;
      for (int i = 0; i < length; i++) {
        Map<String, dynamic> data =
            result.data!['channels']['data'][i]['attributes'];
        data.remove('__typename');
        data.addEntries({
          'id': int.parse(result.data!['channels']['data'][i]['id'])
        }.entries);
        channles.add(ChannelResponseModel.fromJson(data));
      }

      if (result.hasException) {}
      return channles;
    } catch (e) {
      print('Exception Ocurred file fetching list of channels');
    }
    return [];
  }

  Future<Either<String, DateTime>> fetchChannelTimeStamp() async {
    try {
      QueryResult result = await client
          .query(
        QueryOptions(
          cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(_fetchChannelsTimeStampQuery),
        ),
      )
          .timeout(Duration(seconds: 15), onTimeout: () {
        throw TimeoutException('Timeout please reload');
      });

      return right(
        DateTime.parse(
          result.data!['channelTimestamps']['data'][0]['attributes']
              ['timestamp'],
        ),
      );
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<int> createChannel(
      String channelName, int userId, String chatGroupId) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(_createChannelAndUpdateTimestamp),
          variables: <String, dynamic>{
            "data": {
              "channel_name": channelName,
              "user_id": userId,
              "chat_group_id": chatGroupId,
            },
            "updateChannelTimestampData2": {
              "timestamp": DateTime.now().toString()
            }
          },
        ),
      );

      return int.parse(result.data!['createChannel']['data']['id']);
    } catch (e) {
      print('error occured :: $e');
      return 0;
    }
  }

  Future<Either<String, bool>> deleteChannelAndUpdateTimestamp(
      int channelId) async {
    try {
      await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(_deleteChannelAndUpdateTimestamp),
          variables: <String, dynamic>{
            "channelId": channelId,
            "updatetimestamp": {
              "timestamp": DateTime.now().toString(),
            }
          },
        ),
      );
      return Right(true);
    } catch (e) {
      return left("Exception occured while deleteChannelAndUpdateTimestamp ");
    }
  }
}
