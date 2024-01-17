
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/controller/agora_sdk_controller.dart';

class AgoraLobbyScreen extends ConsumerStatefulWidget {
  const AgoraLobbyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AgoraLobbyScreen();
  }
}

class _AgoraLobbyScreen extends ConsumerState<AgoraLobbyScreen> {

late AgoraController channel;

  @override
  void initState()  {
    super.initState();
    initAgoraEngine();
 
  }

  Future<void> initAgoraEngine() async {
       channel = ref.read(agoraControllerProvider(true).notifier);
    await channel.initRtcEngine();
    await channel.configChannel();
    await channel.joinChannel();

  }




  @override
  Widget build(BuildContext context) {
 ref.watch(agoraControllerProvider(true));
 //  final channel = ref.read(agoraControllerProvider(true).notifier);
   
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Agora UI Kit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: channel.videoDisplayScreen()
            ),
            //AgoraVideoButtons(
            //  onDisconnect: () async {
            //    channel.leave();
            //  },
            //  client: client(),
            //),
           // Positioned(
           //   top: 20,
           //   left: 150,
           //   child: LiveAnimation(),
           // ),
           // Positioned(
           //   top: 20,
           //   left: 250,
           //   child: UserCountWidget(),
           // ),
          ],
        ),
      ),
    );
  }
}
