import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/controller/agora_group_chat_controller.dart';
import 'package:social_content_manager/agora/controller/agora_sdk_controller.dart';
import 'package:social_content_manager/agora/widgets/chat_box_widget.dart';
import 'package:tuple/tuple.dart';

class AgoraLobbyScreen extends ConsumerStatefulWidget {
  final bool isBroadcaster;
  final String channelName;
  String groupId;
  AgoraLobbyScreen({
    super.key,
    this.groupId = '',
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
  late AgoraGroupChatController agoraChat;
  final TextEditingController _commentController = TextEditingController();

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
    agoraChat = ref.read(agoraGroupChatContollerProvider.notifier);
    List<Future<bool>> futures = [
      initAgoraEngine(),
      initAgoraChat(),
    ];
    Future.wait(futures).then(
      (value) => {
        if (value[0] && value[1])
          {
            createChannelAndChatGroup(),
          }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    sdk.leave();
    if (widget.isBroadcaster) {
      agoraChat.destoryChatGroup(widget.groupId);
    } else {
      agoraChat.leaveGroup(widget.groupId);
    }
  }

  Future<bool> initAgoraEngine() async {
    await sdk.initRtcEngine();
    await sdk.configChannel();
    await sdk.joinChannel();
    return true;
  }

  Future<bool> initAgoraChat() async {
    await agoraChat.setupChatClient();
    agoraChat.setupListeners();
    await agoraChat.login();
    return true;
  }

  Future<void> createChannelAndChatGroup() async {
    if (widget.isBroadcaster) {
      widget.groupId = await agoraChat.createChatGroup();
      sdk.createChannel(widget.groupId);
    } else {
      agoraChat.joinGroupChat(widget.groupId);
    }
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

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Center(child: sdk.videoDisplayScreen()),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            sdk.leave();
                            if (widget.isBroadcaster) {
                              agoraChat.destoryChatGroup(widget.groupId);
                            } else {
                              agoraChat.leaveGroup(widget.groupId);
                            }
                          },
                          icon: Icon(
                            size: 30,
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 120, right: 20, left: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: const <Color>[
                              Colors.transparent,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: ChatBoxWidget()),
                  ),
                )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _commentController,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    splashColor: Colors.amber,
                    splashRadius: 20,
                    iconSize: 20,
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        agoraChat.sendMessage(
                          groupId: widget.groupId,
                          message: _commentController.text,
                        );
                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  hintText: _commentController.text.isEmpty ? 'Comment' : '',
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.black.withOpacity(0.6),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(width: 0, style: BorderStyle.none))),
            ),
          ),
        ),
      ),
    );
  }
}
