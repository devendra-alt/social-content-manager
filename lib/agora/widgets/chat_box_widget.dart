import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/controller/agora_group_chat_controller.dart';

class ChatBoxWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageList = ref.watch(agoraGroupChatContollerProvider);
    return Container(
      padding:EdgeInsets.only(bottom:20),
        height:300,
       child: ListView.builder(
        
     reverse: true,
        
        itemBuilder: (context, pos) {
          return Container(
            width: double.infinity,
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:  [
                  Text(messageList[pos].senderUsername,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(messageList[pos].content,
                      style: TextStyle(color: Colors.white)),
                ],
              ));
        },
        itemCount:messageList.length ,
      ),
    );
  }
}
