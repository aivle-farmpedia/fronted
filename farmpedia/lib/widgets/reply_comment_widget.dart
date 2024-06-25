import 'package:flutter/material.dart';

class ReplyCommentWidget extends StatelessWidget {
  final List<String> replies;
  final TextEditingController replyController;
  final int replyIndex;
  final Function(int) showReplyInput;
  final Function(int, String) addReply;

  const ReplyCommentWidget({
    super.key,
    required this.replies,
    required this.replyController,
    required this.replyIndex,
    required this.showReplyInput,
    required this.addReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...replies.map((reply) => Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 4.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(reply),
              ),
            )),
        if (replyIndex != -1)
          TextField(
            controller: replyController,
            decoration: InputDecoration(
              labelText: '답글을 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onSubmitted: (value) => addReply(replyIndex, value),
          ),
      ],
    );
  }
}
