import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_content_manager/agora/controller/channel_controller.dart';
import 'package:social_content_manager/agora/widgets/live_channels_list_item.dart';

class LiveChannelsScreen extends ConsumerWidget {
  const LiveChannelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsProvider = ref.watch(fetchChannelFutureProvider(context));
    RefreshController _refreshController = RefreshController(
      initialRefresh: false,
    ); 
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Channels'),
      ),
      body: channelsProvider.when(
        data: (data) {
          return SmartRefresher(
           enablePullUp:false,
            enablePullDown:true,
            enableTwoLevel:false,
            controller: _refreshController,
            child: ListView.builder(
              itemBuilder: (context, pos) {
                return LiveChannelListItem(
                  channelName: data[pos].channelName,
                  userId: data[pos].userId,
                  groupId:data[pos].chatGroupId,
                );
              },
              itemCount: data.length,
            ),
          );
        },
        error: (error, stack) {
          return Text('error');
        },
        loading: () {
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
