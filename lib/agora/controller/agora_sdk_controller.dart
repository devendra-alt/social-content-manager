import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_content_manager/agora/ag_credentials.dart';
import 'package:social_content_manager/agora/channel_model.dart';
import 'package:social_content_manager/agora/repository/fetch_token.dart';
import 'package:social_content_manager/agora/user.dart';

final agoraControllerProvider = StateNotifierProvider.family(
  (ref, bool isBroadcaster) {
    return AgoraController(
        isBroadcaster: isBroadcaster,
        rtcTokenService: ref.read(rtcTokenGeneratorRepository));
  },
);

class AgoraController extends StateNotifier<ChannelModel> {
  RtcEngine? _agoraEngine;
  final String _appId = AgoraCredentials.appId;
  final bool _isBroadcaster;
  final RtcTokenService _rtcTokenService;
  AgoraController(
      {required bool isBroadcaster, required RtcTokenService rtcTokenService})
      : _isBroadcaster = isBroadcaster,
        _rtcTokenService = rtcTokenService,
        super(
          ChannelModel(
            createdUserId: User.host['uid'],
            channelName: User.host['channel'],
            isJoined: false,
            remoteUids: [],
            tokenId: User.host['token'],
          ),
        );

  Future<void> initRtcEngine() async {
    await [Permission.microphone, Permission.camera].request();
    _agoraEngine = createAgoraRtcEngine();
    await _agoraEngine!.initialize(RtcEngineContext(appId: _appId));
    await _agoraEngine!.enableVideo();
  }

  bool get getIsjoined {
    return state.isJoined;
  }

  Future<void> configChannel() async {
    await _agoraEngine!
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    if (_isBroadcaster) {
      await _agoraEngine!
          .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      await _agoraEngine!
          .setClientRole(role: ClientRoleType.clientRoleAudience);
    }

    _agoraEngine!.registerEventHandler(getEventHandler());
  }

  ChannelMediaOptions getChannelMediaOptions() {
    if (_isBroadcaster) {
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
      onConnectionStateChanged: (RtcConnection connection,
          ConnectionStateType state, ConnectionChangedReasonType reason) {
        if (reason ==
            ConnectionChangedReasonType.connectionChangedLeaveChannel) {}
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        state = state.copyWith(isJoined: true);
      },
    );
  }

  Future<String> generateToken(
      {required uid,
      required String channelName,
      required bool isBroadcaster}) async {
    return await _rtcTokenService.fetchTokenSerice(
      uid: uid,
      channelName: channelName,
      isBroadcaster: isBroadcaster,
    );
  }

  Future<void> joinChannel() async {
    await _agoraEngine!.startPreview();
    String token = await generateToken(
      uid: User.host['uid'],
      channelName: User.host['channel'],
      isBroadcaster: _isBroadcaster,
    );

    await _agoraEngine!.joinChannel(
        token:token,
        channelId: User.host['channel'],
        uid: User.host['uid'],
        options: getChannelMediaOptions());
  }

  AgoraVideoView remoteVideoView(int remoteUid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _agoraEngine!,
        canvas: VideoCanvas(uid: remoteUid),
        connection: RtcConnection(channelId: state.channelName),
      ),
    );
  }

  AgoraVideoView localVideoView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _agoraEngine!,
        canvas: const VideoCanvas(uid: 0), // Use uid = 0 for local view
      ),
    );
  }

  Future<void> leave() async {
    try {
      state.remoteUids.clear();

      if (_agoraEngine != null) {
        await _agoraEngine!.leaveChannel();
      }
      destroyAgoraEngine();
      // Navigator.of(context).pop();
    } catch (e) {
      print("Error occured::" + e.toString());
    }
  }

  void destroyAgoraEngine() {
    if (_agoraEngine != null) {
      _agoraEngine!.release();
      _agoraEngine = null;
    }
  }

  Widget videoDisplayScreen() {
    if (state.isJoined) {
      if (_isBroadcaster) {
        return localVideoView();
      } else {
        if (state.remoteUids.isEmpty) {
          return CircularProgressIndicator();
        } else {
          return remoteVideoView(state.remoteUids.first);
        }
      }
    } else {
      return CircularProgressIndicator();
    }
  }
}
