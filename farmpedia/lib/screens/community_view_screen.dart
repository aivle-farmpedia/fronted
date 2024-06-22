import 'package:farmpedia/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityViewScreen extends StatefulWidget {
  final String title;
  final String content;
  final int boardId;
  final String id;

  const CommunityViewScreen({
    super.key,
    required this.title,
    required this.content,
    required this.boardId,
    required this.id,
  });

  @override
  _CommunityViewScreenState createState() => _CommunityViewScreenState();
}

class _CommunityViewScreenState extends State<CommunityViewScreen> {
  final List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final comments = prefs.getStringList('comments_${widget.title}') ?? [];
    setState(() {
      _comments.addAll(comments);
    });
  }

  void _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('comments_${widget.title}', _comments);
  }

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      try {
        await ApiService().postComment(
          _commentController.text,
          widget.boardId,
          widget.id,
        );
        setState(() {
          _comments.add(_commentController.text);
          _commentController.clear();
        });
        _saveComments();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물 보기'),
        backgroundColor: const Color(0xff95C461),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const Text(
              '댓글',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(_comments[index]),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: '댓글을 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onSubmitted: (value) => _addComment(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  '목록',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
