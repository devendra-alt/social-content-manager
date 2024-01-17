import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:social_content_manager/agora/live_widget.dart';
import 'package:social_content_manager/agora/user_count_widget.dart';

class AgoraBroadCasting extends StatefulWidget {
  final bool isBroadcaster;
  final String channelName;
  final Map<String, dynamic> user;
  const AgoraBroadCasting(
      {super.key,
      required this.isBroadcaster,
      required this.channelName,
      required this.user});

  @override
  State<StatefulWidget> createState() {
    return _AgoraBroadCastingState();
  }
}

class _AgoraBroadCastingState extends State<AgoraBroadCasting> {
  late Map<String, dynamic> config; // Configuration parameters
  int localUid = 0;
  String appId = "84e3ffd0e83f48bca9922bfd3e2818c1";
  String channelName = "Channel2";
  List<int> remoteUids = []; // Uids of remote users in the channel
  bool isJoined = false; // Indicates if the local user has joined the channel
  RtcEngine? agoraEngine; // Agora engine instance

  bool get isBroadcaster => widget.isBroadcaster;

  Future<void> setupAgoraEngine() async {
    // Retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    // Create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine!.initialize(RtcEngineContext(appId: appId));

    await agoraEngine!.enableVideo();
    await agoraEngine!
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

    if (isBroadcaster) {
      await agoraEngine!
          .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await agoraEngine!.setClientRole(role: ClientRoleType.clientRoleAudience);
    }
    // Register the event handler
    agoraEngine!.registerEventHandler(getEventHandler());

    agoraEngine!.startPreview();

    await agoraEngine!.joinChannel(
        token: widget.user['token'],
        channelId: widget.user['channel'],
        uid: widget.user['uid'],
        options: getChannelMediaOptions());
  }

  ChannelMediaOptions getChannelMediaOptions() {
    if (isBroadcaster) {
      return ChannelMediaOptions(
        autoSubscribeAudio: false,
        autoSubscribeVideo: false,
      );
    }
    return ChannelMediaOptions(
      autoSubscribeAudio: true,
      autoSubscribeVideo: true,
    );
  }

  RtcEngineEventHandler getEventHandler() {
    return RtcEngineEventHandler(
      // Occurs when the network connection state changes
      onConnectionStateChanged: (RtcConnection connection,
          ConnectionStateType state, ConnectionChangedReasonType reason) {
        if (reason ==
            ConnectionChangedReasonType.connectionChangedLeaveChannel) {
          remoteUids.clear();
          isJoined = false;
        }
      },
      // Occurs when a local user joins a channel
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        setState(() {
          isJoined = true;
        });
      },

      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        setState(() {
          remoteUids.add(remoteUid);
        });
        print("Remote User Joined:: $remoteUids");
      },
      // Occurs when a remote user leaves the channel
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        remoteUids.remove(remoteUid);
      },

      onFirstRemoteVideoFrame:
          (connection, remoteUid, width, height, elapsed) => setState(() {}),
    );
  }

  AgoraVideoView remoteVideoView(int remoteUid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: agoraEngine!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: channelName),
      ),
    );
  }

  AgoraVideoView localVideoView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: agoraEngine!,
        canvas: const VideoCanvas(uid: 0), // Use uid = 0 for local view
      ),
    );
  }

  Future<void> leave() async {
    try {
      // Clear saved remote Uids
      remoteUids.clear();

      // Leave the channel
      if (agoraEngine != null) {
        await agoraEngine!.leaveChannel();
      }

      isJoined = false;

      destroyAgoraEngine();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error occured::" + e.toString());
    }
  }

  void destroyAgoraEngine() {
    // Release the RtcEngine instance to free up resources
    if (agoraEngine != null) {
      agoraEngine!.release();
      agoraEngine = null;
    }
  }

  AgoraClient client() {
    if (isBroadcaster) {
      return AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            uid: 10,
            appId: '84e3ffd0e83f48bca9922bfd3e2818c1',
            channelName: 'Channel2',
            tempToken:
                '007eJxTYLB5W/A641RJt9w3LfcrLToH1l80yO6wchB5u0Hc+OlGtzIFBguTVOO0tBSDVAvjNBOLpORES0sjo6S0FONUIwtDi2RD+8plqQ2BjAyKz3mZGRkgEMTnYHDOSMzLS80xYmAAAPvvIMw='),
      );
    }
    return AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: '84e3ffd0e83f48bca9922bfd3e2818c1',
          channelName: 'Channel2',
          tempToken:
              '007eJxTYFhwoTNs7qJrtjfdX08M31GrX9b1PiiP48X21H//8hzfL2ZUYLAwSTVOS0sxSLUwTjOxSEpOtLQ0MkpKSzFONbIwtEg2VN+0LLUhkJHhOZsBAyMUgvgcDM4ZiXl5qTlGDAwAquYi+w==',
          uid: 20),
    );
  }

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await setupAgoraEngine();
  }

  Widget videoDisplayScreen() {
    if (isJoined) {
      if (isBroadcaster) {
        return localVideoView();
      } else {
        if (remoteUids.isEmpty) {
          return CircularProgressIndicator();
        } else {
          return remoteVideoView(remoteUids.first);
        }
      }
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora UI Kit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: videoDisplayScreen(),
            ),
            AgoraVideoButtons(
              onDisconnect: () async {
                leave();
              },
              client: client(),
            ),
            Positioned(
              top: 20,
              left: 150,
              child: LiveAnimation(),
            ),
            Positioned(
              top: 20,
              left: 250,
              child: UserCountWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
