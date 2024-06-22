import 'package:flutter/material.dart';

import '../services/api_service.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String content;
  final String id;
  final int boardId;
  final int boardUserId;
  final int privateId;
  final Function onDelete;

  const PostCard({
    super.key,
    required this.title,
    required this.content,
    required this.id,
    required this.boardId,
    required this.boardUserId,
    required this.privateId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '익명의 농부',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (boardUserId == privateId)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, boardId, id);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int boardId, String id) {
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
                _deletePost(context, boardId, id);
              },
              child: const Text("삭제"),
            ),
          ],
        );
      },
    );
  }

  void _deletePost(BuildContext context, int boardId, String id) async {
    String userId = id;

    bool del = await ApiService().deleteBoard(userId, boardId);

    if (del == true) {
      Navigator.of(context).pop();
      onDelete();
    } else {
      debugPrint("실패");
    }
  }
}
