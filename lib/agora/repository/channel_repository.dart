import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/agora/channel_response_model.dart';
import 'package:social_content_manager/service/auth/Secure.dart';

final channelRepositiryProvider = Provider((ref) {
  return ChannelRepositiry(ref: ref);
});

final graphqlClientProvider = Provider((ref) {
  return useGraphQLClient();
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
  final Ref _ref;
  ChannelRepositiry({required Ref ref}) : _ref = ref;
  static const String _fetchChannelQuery = """
query Query {
  channels {
    data {
      attributes {
        channel_id
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
      final length= result.data!['channels']['data'].length;
     
      for (int i = 0; i < length; i++) {
        print("Length::${result.data!.length}");
        Map<String, dynamic> data =
            result.data!['channels']['data'][i]['attributes'];
        data.remove('__typename');
        channles.add(ChannelResponseModel.fromJson(data));
      }

      if (result.hasException) {}
      return channles;
    } catch (e) {
      print('Exception Ocurred file fetching list of channels');
    }
    return [];
  }

  Future<DateTime> fetchChannelTimeStamp() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(_fetchChannelsTimeStampQuery),
        ),
      );
      return DateTime.parse(
        result.data!['channelTimestamps']['data'][0]['attributes']['timestamp'],
      );
    } catch (e) {
      print('exception occured $e');
    }
    return DateTime.now();
  }
}
