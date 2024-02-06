class ChannelResponseModel {
  final int channelId;
  final int userId;
  final String channelName;
  final String chatGroupId;

  ChannelResponseModel(
      {required this.channelId,
      required this.channelName,
      required this.userId,
      required this.chatGroupId});

  ChannelResponseModel.fromJson(Map<String, dynamic> map)
      : channelId = map['id'],
        userId = map['user_id'],
        channelName = map['channel_name'],
        chatGroupId = map['chat_group_id'];
}
