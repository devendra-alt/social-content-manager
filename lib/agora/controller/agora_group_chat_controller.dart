import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/controller/agora_messaging_controller2.dart';
import 'package:social_content_manager/service/auth/controller/auth_controller.dart';

final agoraGroupChatContollerProvider = StateNotifierProvider.family<
    AgoraGroupChatController, List<String>, String>((ref, groupId) {
  return AgoraGroupChatController(
      groupId: groupId,
      authController: ref.read(authControllerProvider.notifier));
});

class AgoraGroupChatController extends StateNotifier<List<String>> {
  final String _groupId;
  final AuthController _authController;
  late ChatClient agoraChatClient;
  static const String appKey = "611085688#1266091";
  static const String userId = '20';
  String token =
      "007eJxTYGjv2XQ6cPnWhrzri65buUzZYNq6b/Hq/a9WLVmfqBqwT1VHgcHCJNU4LS3FINXCOM3EIik50dLSyCgpLcU41cjC0CLZ0CpwV2pDICPDH8ckRkYGVgZGIATxVRjMTVNTTJJTDHST0kzNdQ0NU1N1E01MTXQtkhIN0kzMLZPNEk0Ag24p6w==";

  AgoraGroupChatController(
      {required String groupId, required AuthController authController})
      : _groupId = groupId,
        _authController = authController,
        super(
          [],
        );

  String getUserId() {
    return _authController.userId.toString();
  }

  showLog(String message) {
    //scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    // content: Text(message),
    //));
  }

  Future<void> setupChatClient() async {
    ChatOptions options = ChatOptions(
      acceptInvitationAlways: false,
      appKey: appKey,
      autoLogin: false,
    );
    agoraChatClient = ChatClient.getInstance;
    await agoraChatClient.init(options);

// Notify the SDK that the Ul is ready. After the following method is executed, callbacks within ChatRoomEventHandler and ChatGroupEventHandler can be triggered.
    await ChatClient.getInstance.startCallback();
  }

  void setupListeners() {
    agoraChatClient.addConnectionEventHandler(
      "CONNECTION_HANDLER",
      getConnectionEventHandler(),
    );
    agoraChatClient.chatManager.addMessageEvent(
      'MESSAGE_HANDLER',
      getChatMessageEvent(),
    );
    agoraChatClient.chatManager.addEventHandler(
      'CHAT_HANDLER',
      getChatEventHandler(),
    );
    agoraChatClient.groupManager.addEventHandler(
      'EVENT_HANDLER',
      getChatGroupEventHandler(),
    );
  }

  ChatGroupEventHandler getChatGroupEventHandler() {
    return ChatGroupEventHandler(
      onInvitationReceivedFromGroup: (String? groupId, String? groupName,
          String? inviter, String? reason) {},
      onMemberJoinedFromGroup: (groupId, member) {},
    );
  }

  ChatEventHandler getChatEventHandler() {
    return ChatEventHandler(onMessagesReceived: (List<ChatMessage> messages) {
      for (var msg in messages) {
        if (msg.body.type == MessageType.TXT) {
          ChatTextMessageBody body = msg.body as ChatTextMessageBody;
          // displayMessage(body.content, false);
          showLog("Message from ${msg.from}");
        } else {
          String msgType = msg.body.type.name;
          showLog("Received $msgType message, from ${msg.from}");
        }
      }
    });
  }

  ChatMessageEvent getChatMessageEvent() {
    return ChatMessageEvent(
      onSuccess: (msgId, msg) {
        //  _addLogToConsole("on message succeed");
      },
      onProgress: (msgId, progress) {
        //   _addLogToConsole("on message progress");
      },
      onError: (msgId, msg, error) {
        //  _addLogToConsole(
        //    "on message failed, code: ${error.code}, desc: ${error.description}",
//);
      },
    );
  }

  ConnectionEventHandler getConnectionEventHandler() {
    return ConnectionEventHandler(
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onTokenWillExpire: onTokenWillExpire,
        onTokenDidExpire: onTokenDidExpire);
  }

  void onTokenWillExpire() {
    // The token is about to expire. Get a new token
    // from the token server and renew the token.
  }
  void onTokenDidExpire() {
    // The token has expired
  }
  void onDisconnected() {
    // Disconnected from the Chat server
  }
  void onConnected() {
    showLog("Connected");
  }

  Future<void> login() async {
    try{
    await agoraChatClient.loginWithAgoraToken(userId, token);
    }on ChatError catch(e){
    }
  }

  void sendMessage() async {
    var msg = ChatMessage.createTxtSendMessage(
        targetId: '', chatType: ChatType.GroupChat, content: 'hello');

    ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    agoraChatClient.chatManager.sendMessage(msg);
  }

  Future<String> createChatGroup() async {
    ChatGroupOptions option = ChatGroupOptions(
      maxCount: 100,
      style: ChatGroupStyle.PublicOpenJoin,
    );
    ChatGroup chatGroup = await agoraChatClient.groupManager
        .createGroup(options: option, groupName: 'newgroup');

    return chatGroup.groupId;
  }

  Future<void> joinGroupChat(String groupId) async {
    await agoraChatClient.groupManager.joinPublicGroup(groupId);
  }
}
