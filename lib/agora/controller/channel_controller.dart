import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/channel_controller_model.dart';
import 'package:social_content_manager/agora/channel_response_model.dart';
import 'package:social_content_manager/agora/repository/channel_repository.dart';

final channelControllerProvider = StateNotifierProvider(
  (ref) {
    final channelRepositiry = ref.read(channelRepositiryProvider);
    return ChannelController(
      channelRepositiry: channelRepositiry,
    );
  },
);

final fetchChannelFutureProvider = FutureProvider.family(
  (ref, BuildContext context) {
    final channelProvider = ref.read(channelControllerProvider.notifier);
    return channelProvider.getChannelList();
  },
);

class ChannelController extends StateNotifier<ChannelControllerModel> {
  final ChannelRepositiry _channelRepository;

  ChannelController({required ChannelRepositiry channelRepositiry})
      : _channelRepository = channelRepositiry,
        super(
          ChannelControllerModel(
            channels: [],
            timeStamp: DateTime.now(),
          ),
        );

  DateTime get getChannelTimeStamp {
    return state.getTimeStamp;
  }

  Future<List<ChannelResponseModel>> getChannelList() async {
    List<ChannelResponseModel> channels = [];
    DateTime timeStamp = await _channelRepository.fetchChannelTimeStamp();

    if (!isSameAsRemoteTimeStamp(timeStamp)) {
      channels = await _channelRepository.fetchOngoingChannels();
      print("heheaeae ${channels.length}");
      state = state.copyWith(channelData: channels, dateData: timeStamp);
    }
    return state.listOfChannels;
  }

  bool isSameAsRemoteTimeStamp(DateTime remoteTimeStamp) {
    DateTime localTimeStamp = state.getTimeStamp;
    print('local time :: $localTimeStamp');
    print('remote TIME:: $remoteTimeStamp');
    if (localTimeStamp.isAtSameMomentAs(remoteTimeStamp)) {
      return true;
    }
    return false;
  }
}
