class ChannelResponseModel {
  final int userId;
  final String channelName;
  final String channelId;

  ChannelResponseModel({
    required this.channelId,
    required this.channelName,
    required this.userId,
  });

  ChannelResponseModel.fromJson(Map<String, dynamic> map)
      : userId = map['user_id'],
        channelId = map['channel_id'],
        channelName = map['channel_name'];

  
}
