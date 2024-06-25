import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'community_screen.dart';

class CommunityEditScreen extends StatefulWidget {
  final String title;
  final String content;
  final int boardId;
  final int id;
  final String privateId;

  const CommunityEditScreen({
    super.key,
    required this.title,
    required this.content,
    required this.boardId,
    required this.id,
    required this.privateId,
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

  Future<void> _updatePost() async {
    debugPrint("hello");
    String newTitle = _titleController.text;
    String newContent = _contentController.text;

    bool updated = await ApiService().putBoard(
      newTitle,
      newContent,
      widget.privateId,
      widget.boardId,
    );
    debugPrint(updated.toString());

    if (updated) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityScreen(
            id: widget.id,
            privateId: widget.privateId,
          ),
        ),
      );
    } else {
      debugPrint("수정 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 수정'),
        backgroundColor: const Color(0xff95C461),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updatePost,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              ElevatedButton(
                onPressed: _updatePost,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
