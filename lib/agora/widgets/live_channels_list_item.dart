import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:social_content_manager/agora/screens/ag_lobby_screen.dart';

class LiveChannelListItem extends ConsumerWidget {
  final String channelName;
  final int userId;
  final String groupId;

  const LiveChannelListItem({
    super.key,
    required this.channelName,
    required this.userId,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 2,
      child: ListTile(
        tileColor: Colors.white,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AgoraLobbyScreen(
                isBroadcaster: false,
                channelName: channelName,
                groupId:groupId ,
              ),
            ),
          );
        },
        splashColor: Colors.black.withOpacity(0.2),
        leading: CircleAvatar(
          radius:30,
          backgroundImage:AssetImage('assets/frame2/live_frame.png',),
          backgroundColor:Colors.transparent,
          
               ),
       
        title: Text(channelName),
        subtitle: Text(
          'User Id : $userId',
        ),
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
