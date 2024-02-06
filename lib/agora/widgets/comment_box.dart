import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_content_manager/agora/controller/agora_group_chat_controller.dart';

class CommentBoxWidget extends ConsumerStatefulWidget {
  final AgoraGroupChatController agoraChat;
  final String groupId;
  const CommentBoxWidget(
      {super.key, required this.agoraChat, required this.groupId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CommentBoxWidgetState();
  }
}

class _CommentBoxWidgetState extends ConsumerState<CommentBoxWidget> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        controller: _commentController,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              splashColor: Colors.amber,
              splashRadius: 20,
              iconSize: 20,
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  widget.agoraChat.sendMessage(
                    groupId: widget.groupId,
                    message: _commentController.text,
                  );
                  _commentController.clear();
                }
              },
            ),
            hintText: _commentController.text.isEmpty ? 'Comment' : '',
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Colors.black.withOpacity(0.6),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0, style: BorderStyle.none))),
      ),
    );
  }
}
