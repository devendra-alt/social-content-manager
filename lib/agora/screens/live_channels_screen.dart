import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_content_manager/agora/controller/channel_controller.dart';
import 'package:social_content_manager/agora/widgets/live_channels_list_item.dart';

class LiveChannelsScreen extends ConsumerWidget {
  const LiveChannelsScreen({super.key});

  Widget showErrorDialogBox(BuildContext context, String errorMessage) {
    return AlertDialog(
      title: Text('Oops!'),
      content: Text(errorMessage),
      // Customize content with your desired elements
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            // Implement contact support logic here

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsProvider = ref.watch(fetchChannelFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Channels'),
      ),
      body: channelsProvider.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/empty-box.png',
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'No ongoing streams',
                    style: TextStyle(color: Colors.grey.shade400),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, pos) {
              return LiveChannelListItem(
                channelName: data[pos].channelName,
                userId: data[pos].userId,
                groupId: data[pos].chatGroupId,
              );
            },
            itemCount: data.length,
          );
        },
        error: (error, stack) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/error.gif',width:80,fit: BoxFit.cover,),
              Text(
          
                'Timeout error occured, please reload',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.red,
                  fontSize:20,
                ),
              )
            ],
          ));
        },
        loading: () {
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
/*           if (data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/empty-box.png',
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'No ongoing streams',
                        style: TextStyle(color: Colors.grey.shade400),
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, pos) {
                  return LiveChannelListItem(
                    channelName: data[pos].channelName,
                    userId: data[pos].userId,
                    groupId: data[pos].chatGroupId,
                  );
                },
                itemCount: data.length,
              );*/