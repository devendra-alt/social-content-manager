import 'package:social_content_manager/agora/channel_response_model.dart';

class ChannelControllerModel {
  final DateTime timeStamp;
  final List<ChannelResponseModel> channels;

  ChannelControllerModel({
    required this.channels,
    required this.timeStamp,
  });

  DateTime get getTimeStamp {
    return timeStamp;
  }

  List<ChannelResponseModel> get listOfChannels {
    return channels;
  }

  ChannelControllerModel copyWith(
      {DateTime? dateData, List<ChannelResponseModel>? channelData}) {
    return ChannelControllerModel(
      channels: channelData ?? channels,
      timeStamp: dateData ?? timeStamp,
    );
  }
}
