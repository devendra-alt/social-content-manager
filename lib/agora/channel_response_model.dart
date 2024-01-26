class ChannelResponseModel {
  final int userId;
  final String channelName;

  ChannelResponseModel({
    required this.channelName,
    required this.userId,
  });

  ChannelResponseModel.fromJson(Map<String, dynamic> map)
      : userId = map['user_id'],
        channelName = map['channel_name'];
}
