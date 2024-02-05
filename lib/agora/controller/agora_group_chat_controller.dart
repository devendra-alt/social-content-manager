import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/message_model.dart';
import 'package:social_content_manager/agora/repository/fetch_token.dart';

import 'package:social_content_manager/service/auth/controller/auth_controller.dart';
import 'package:social_content_manager/service/auth/secure.dart';

final agoraGroupChatContollerProvider =
    StateNotifierProvider<AgoraGroupChatController, List<Message>>(
  (ref) {
    return AgoraGroupChatController(
        agoraTokenRepo: ref.read(rtcTokenGeneratorRepository),
        authController: ref.read(authControllerProvider.notifier));
  },
);

class AgoraGroupChatController extends StateNotifier<List<Message>> {
  final AuthController _authController;
  final RtcTokenService _agoraTokenRepo;
  late ChatClient agoraChatClient;
  static const String appKey = "611085688#1266091";

  AgoraGroupChatController(
      {required RtcTokenService agoraTokenRepo,
      required AuthController authController})
      : _agoraTokenRepo = agoraTokenRepo,
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

  void leaveGroup(String groupId) {
    agoraChatClient.groupManager.leaveGroup(groupId);
    agoraChatClient.groupManager.removeEventHandler('EVENT_HANDLER');
    agoraChatClient.chatManager.removeMessageEvent('MESSAGE_HANDLER');
    agoraChatClient.chatManager.removeEventHandler('CHAT_HANDLER');
    agoraChatClient.removeConnectionEventHandler('MESSAGE_HANDLER');
  }

  ChatGroupEventHandler getChatGroupEventHandler() {
    return ChatGroupEventHandler(
      onInvitationReceivedFromGroup: (String? groupId, String? groupName,
          String? inviter, String? reason) {},
      onMemberJoinedFromGroup: (groupId, member) {},
    );
  }

  ChatEventHandler getChatEventHandler() {
    return ChatEventHandler(
      onMessagesReceived: (List<ChatMessage> messages) {
        List<Message> updatedList = [];
        for (var msg in messages) {
          ChatTextMessageBody body = msg.body as ChatTextMessageBody;

          updatedList.add(
            Message(content: body.content , senderUsername:msg.from ?? 'Guest' ),
          );
        }
        updatedList+=[...state];
        state = updatedList;
      },
    );
  }

  ChatMessageEvent getChatMessageEvent() {
    return ChatMessageEvent(
      onSuccess: (msgId, msg) {
      List<Message> updatedList =[];
      ChatTextMessageBody message = msg.body as ChatTextMessageBody;
      updatedList.add(Message(content:message.content, senderUsername:msg.from ?? ''));
      updatedList+=[...state];
      state = updatedList;
      },
      onProgress: (msgId, progress) {
        //   _addLogToConsole("on message progress");
      },
      onError: (msgId, msg, error) {
        print('error');
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

  Future<String> getUserChatToken() async {
    return await _agoraTokenRepo.fetchUserToken(_authController.username);
  }

  Future<void> login() async {
    try {
      String? userToken = await readFromSecureStorage('userChatToken');
      // if (userToken == null) {
      userToken = await getUserChatToken();
      writeToSecureStorage('userChatToken', userToken);
      //}
      await agoraChatClient.loginWithAgoraToken(
          _authController.username, userToken);
    } on ChatError catch (e) {}
  }

  void sendMessage({required String groupId, required String message}) async {
    var msg = ChatMessage.createTxtSendMessage(
      targetId: groupId,
      chatType: ChatType.GroupChat,
      content: message,
    );

    // ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    agoraChatClient.chatManager.sendMessage(msg);
  }

  Future<String> createChatGroup() async {
    ChatGroupOptions option = ChatGroupOptions(
      maxCount: 100,
      style: ChatGroupStyle.PublicOpenJoin,
    );
    ChatGroup chatGroup = await agoraChatClient.groupManager
        .createGroup(options: option, groupName: _authController.username);

    return chatGroup.groupId;
  }

  Future<void> joinGroupChat(String groupId) async {
    await agoraChatClient.groupManager.joinPublicGroup(groupId);
  }

  Future<void> destoryChatGroup(String groupId) async {
    agoraChatClient.groupManager.destroyGroup(groupId);
    //agoraChatClient.chatManager.deleteRemoteConversation(groupId,conversationType:ChatConversationType.GroupChat,isDeleteMessage:true);
    agoraChatClient.groupManager.removeEventHandler('EVENT,_HANDLER');
    agoraChatClient.chatManager.removeMessageEvent('MESSAGE_HANDLER');
    agoraChatClient.chatManager.removeEventHandler('CHAT_HANDLER');
    agoraChatClient.removeConnectionEventHandler('MESSAGE_HANDLER');
  }
}
