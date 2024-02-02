import 'package:flutter/material.dart';
import 'package:social_content_manager/agora/screens/ag_lobby_screen.dart';

class AgoraScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AgoraScreenState();
  }
}

class _AgoraScreenState extends State<AgoraScreen> {
  final _channelNameController = TextEditingController();

  void _joinLiveStream(bool isBroadcasting, String channelName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AgoraLobbyScreen(
            isBroadcaster: isBroadcasting, channelName: channelName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streaming'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          TextField(
            controller: _channelNameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Channel Name'),
          ),
          ElevatedButton(
              onPressed: () {
                _joinLiveStream(true, _channelNameController.text);
              },
              child: Text('Broadcast')),
          ElevatedButton(
              onPressed: () {
                _joinLiveStream(false, _channelNameController.text);
              },
              child: Text('Join')),
        ],
      ),
    );
  }
}
