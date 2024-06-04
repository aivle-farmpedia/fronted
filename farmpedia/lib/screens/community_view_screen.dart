import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityViewScreen extends StatefulWidget {
  final String title;
  final String content;

  const CommunityViewScreen({
    super.key,
    required this.title,
    required this.content,
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

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
      _saveComments();
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
              width: double.infinity, // Fill the width of the parent
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
              width: double.infinity, // Fill the width of the parent
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
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    margin:
                        const EdgeInsets.symmetric(vertical: 12.0), // 상하 여백을 늘림
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
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    '추가',
                    style: TextStyle(color: Colors.white),
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
                  '목록으로 돌아가기',
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
