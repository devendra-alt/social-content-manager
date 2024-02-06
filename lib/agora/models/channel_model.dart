class ChannelModel {
  final int createdUserId;
  final String channelName;
  final String tokenId;
  final List<int> remoteUids;
  final bool isJoined;

  ChannelModel(
      {required this.createdUserId,
      required this.channelName,
      required this.tokenId,
      required this.isJoined,
      required this.remoteUids});

  set isJoined(bool val) {
    isJoined = val;
  }

  List<int> addUserToList(int uid){
    remoteUids.add(uid);
    return remoteUids;
  }

  ChannelModel copyWith({
    int? createdUserId,
    String? channelName,
    String? tokenId,
    List<int>? remoteUids,
    bool? isJoined,
  }) {
    return ChannelModel(
      createdUserId: createdUserId ?? this.createdUserId,
      channelName: channelName ?? this.channelName,
      tokenId: tokenId ?? this.tokenId,
      remoteUids: remoteUids ?? this.remoteUids,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}
