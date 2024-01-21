import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_content_manager/service/auth/secure.dart';

class LiveStreamChannelScreen extends ConsumerWidget {
  const LiveStreamChannelScreen({super.key});

  final String readTimestamp = """
query ChannelTime {
  channelTimestamp {
    data {
      attributes {
        timestamp
      }
    }
  }
}
""";

  Future<void> fetchToken() async {
    String token = await readFromSecureStorage('token') as String;
    print(token);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
      ),
      body: Query(
        options: QueryOptions(document: gql(readTimestamp)),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
             fetchToken();
          if (result.hasException) {
            print("Exception Occured ${result.exception.toString()}");
          }
          if (result.isLoading) {
            return CircularProgressIndicator();
          }
          if (result.data != null) {
            return Text(result.data!['timestamp']);
          }
          return Center(
            child: Text('Error'),
          );
        },
      ),
    );
  }
}
