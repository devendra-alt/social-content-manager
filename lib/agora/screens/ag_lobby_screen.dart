import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/ag_credentials.dart';
import 'package:social_content_manager/agora/controller/agora_sdk_controller.dart';
import 'package:tuple/tuple.dart';

class AgoraLobbyScreen extends ConsumerStatefulWidget {
  final bool isBroadcaster;
  final String channelName;
  const AgoraLobbyScreen({
    super.key,
    required this.isBroadcaster,
    required this.channelName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AgoraLobbyScreen();
  }
}

class _AgoraLobbyScreen extends ConsumerState<AgoraLobbyScreen> {
  late AgoraController sdk;

  @override
  void initState() {
    super.initState();

    sdk = ref.read(
      agoraControllerProvider(
        Tuple3(
          widget.isBroadcaster,
          widget.channelName,
          context,
        ),
      ).notifier,
    );
    initAgoraEngine();
  }

  @override
  void dispose() {
    super.dispose();
    sdk.leave();
  }

  Future<void> initAgoraEngine() async {
    await sdk.initRtcEngine();
    await sdk.configChannel();
    await sdk.joinChannel();
    if (widget.isBroadcaster) await sdk.createChannel();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
      agoraControllerProvider(
        Tuple3(
          widget.isBroadcaster,
          widget.channelName,
          context,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora UI Kit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: sdk.videoDisplayScreen()),
            AgoraVideoButtons(
                enabledButtons: widget.isBroadcaster
                    ? [
                        BuiltInButtons.toggleMic,
                        BuiltInButtons.callEnd,
                        BuiltInButtons.switchCamera,
                      ]
                    : [
                        BuiltInButtons.callEnd,
                      ],
                onDisconnect: () async {
                  sdk.leave();
                },
                client: AgoraClient(
                  agoraConnectionData: AgoraConnectionData(
                    appId: AgoraCredentials.appId,
                    channelName: widget.channelName,
                    uid: sdk.userId,
                  ),
                )),
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
