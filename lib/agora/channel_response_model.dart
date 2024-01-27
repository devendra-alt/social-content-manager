class ChannelResponseModel {
  final int channelId;
  final int userId;
  final String channelName;

  ChannelResponseModel({
    required this.channelId,
    required this.channelName,
    required this.userId,
  });

  ChannelResponseModel.fromJson(Map<String, dynamic> map)
      : channelId = map['id'],
        userId = map['user_id'],
        channelName = map['channel_name'];
}
