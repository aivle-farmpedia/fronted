import 'package:flutter/material.dart';

import '../models/chat_rooms_list_model.dart';
import '../screens/gpt_chat_screen.dart';
import '../services/gpt_api_service.dart';

class BuildChatRoomList extends StatelessWidget {
  final String id;
  final int chatRoomId;
  final ChatRoomsList chatRoom;
  final int privateId;
  final Function reLoadFunc;

  const BuildChatRoomList({
    super.key,
    required this.id,
    required this.chatRoomId,
    required this.chatRoom,
    required this.privateId,
    required this.reLoadFunc,
  });

  void _showDeleteConfirmationDialog(
      BuildContext context, String id, int chatRoomId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("게시글 삭제"),
          content: const Text("정말로 이 게시글을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                _deletePost(context, id, chatRoomId);
              },
              child: const Text("삭제"),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(BuildContext context, String id, int chatRoomId) async {
    String userId = id;

    bool del = await GPTApiService().deleteChat(userId, chatRoomId);

    if (del == true) {
      debugPrint("성공");
      reLoadFunc();
      Navigator.of(context).pop();
    } else {
      debugPrint("실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        // title: Text(chatRoom.recentMsg),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              chatRoom.recentMsg.length > 10
                  ? '${chatRoom.recentMsg.substring(0, 10)}...'
                  : chatRoom.recentMsg,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, id, chatRoom.id);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GPTChatScreen(
                id: id,
                privateId: privateId,
                chatRoomId: chatRoom.id,
              ),
            ),
          ).then((_) {
            // Reload futureChatLists when returning to this screen
            reLoadFunc();
          });
        },
      ),
    );
  }
}
