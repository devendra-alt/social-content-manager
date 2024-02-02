import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/ag_credentials.dart';
import 'package:social_content_manager/agora/channel_model.dart';
import 'package:social_content_manager/agora/repository/channel_repository.dart';
import 'package:social_content_manager/agora/repository/fetch_token.dart';
import 'package:social_content_manager/service/auth/controller/auth_controller.dart';
import 'package:tuple/tuple.dart';

final agoraControllerProvider = StateNotifierProvider.family<AgoraController,
    ChannelModel, Tuple3<bool, String, BuildContext>>(
  (ref, Tuple3 tuple) {
    return AgoraController(
        buildContext: tuple.item3,
        channelRepositiry: ref.read(channelRepositiryProvider),
        channelName: tuple.item2,
        authController: ref.read(authControllerProvider.notifier),
        isBroadcaster: tuple.item1,
        rtcTokenService: ref.read(rtcTokenGeneratorRepository));
  },
);

class AgoraController extends StateNotifier<ChannelModel> {
  final BuildContext _buildContext;
  final AuthController _authController;
  late int _channelId;
  RtcEngine? _agoraEngine;
  final String _appId = AgoraCredentials.appId;
  final bool _isBroadcaster;
  final String _channelName;
  final RtcTokenService _rtcTokenService;
  final ChannelRepositiry _channelRepositiry;

  AgoraController({
    required BuildContext buildContext,
    required ChannelRepositiry channelRepositiry,
    required String channelName,
    required bool isBroadcaster,
    required RtcTokenService rtcTokenService,
    required AuthController authController,
  })  : _buildContext = buildContext,
        _channelRepositiry = channelRepositiry,
        _channelName = channelName,
        _authController = authController,
        _isBroadcaster = isBroadcaster,
        _rtcTokenService = rtcTokenService,
        super(
          ChannelModel(
            createdUserId: 0,
            channelName: '',
            isJoined: false,
            remoteUids: [],
            tokenId: '',
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

  int get userId {
    return _authController.userId;
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
      onUserJoined: (connection, remoteUid, elapsed) {
        state = state.copyWith(remoteUids: state.addUserToList(remoteUid));
      },
      onUserOffline: (connection, remoteUid, reason) {
        leave();
      },
    );
  }

  Future<void> createChannel(String groupId) async {
    _channelId = await _channelRepositiry.createChannel(_channelName, userId,groupId);
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
      uid: _authController.userId,
      channelName: _channelName,
      isBroadcaster: _isBroadcaster,
    );

    await _agoraEngine!.joinChannel(
      token: token,
      channelId: _channelName,
      uid: _authController.userId,
      options: getChannelMediaOptions(),
    );
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
        canvas: const VideoCanvas(
          uid: 0,
        ), // Use uid = 0 for local view
      ),
    );
  }

  Future<void> leave() async {
    try {
      state.remoteUids.clear();

      if (_agoraEngine != null) {
        await _agoraEngine!.leaveChannel();
      }
      await destroyAgoraEngine();
      if (_isBroadcaster) {
        await _channelRepositiry.deleteChannelAndUpdateTimestamp(_channelId);
      }
      Navigator.of(_buildContext).pop();
    } catch (e) {
      //throw AgoraException(message: 'Some error occured while leaving channel');
    }
  }

  Future<void> destroyAgoraEngine() async {
    if (_agoraEngine != null) {
      await _agoraEngine!.release();
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
