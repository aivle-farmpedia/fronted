import 'package:flutter/material.dart';

class CommunityEditScreen extends StatefulWidget {
  final String title;
  final String content;
  final int boardId;
  final String id;

  const CommunityEditScreen({
    super.key,
    required this.title,
    required this.content,
    required this.boardId,
    required this.id,
  });

  @override
  _CommunityEditScreenState createState() => _CommunityEditScreenState();
}

class _CommunityEditScreenState extends State<CommunityEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Future<void> _updatePost() async {
  //   String newTitle = _titleController.text;
  //   String newContent = _contentController.text;

  //   bool updated = await ApiService().updateBoard(
  //     widget.id,
  //     widget.boardId,
  //     newTitle,
  //     newContent,
  //   );

  //   if (updated) {
  //     Navigator.of(context).pop(true);
  //   } else {
  //     debugPrint("수정 실패");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 수정'),
        backgroundColor: const Color(0xff95C461),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '내용'),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
