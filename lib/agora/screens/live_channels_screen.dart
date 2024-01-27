import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/controller/channel_controller.dart';
import 'package:social_content_manager/agora/screens/ag_lobby_screen.dart';

class LiveChannelsScreen extends ConsumerWidget {
  const LiveChannelsScreen({super.key});

 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelsProvider = ref.watch(fetchChannelFutureProvider(context));

    
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Channels'),
      ),
      body: channelsProvider.when(
        data: (data) {
          return ListView.builder(
              itemBuilder: (context, pos) {
                return Card(
                  
                  margin:EdgeInsets.all(10),
                  elevation:2,
                  child: ListTile(
                  tileColor:Colors.white ,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AgoraLobbyScreen(
                              isBroadcaster: false,
                              channelName: data[pos].channelName),
                        ),
                      );
                    },
                    splashColor:Colors.black.withOpacity(0.2),
                    title: Text(data[pos].channelName),
                    style: ListTileStyle.list,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              itemCount: data.length);
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
