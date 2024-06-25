import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../widgets/backpage_widget.dart';
import '../widgets/menu_widget.dart';

class CommunityWriteScreen extends StatefulWidget {
  final int id;
  final String privateId;

  const CommunityWriteScreen({
    super.key,
    required this.id,
    required this.privateId,
  });

  @override
  _CommunityWriteScreenState createState() => _CommunityWriteScreenState();
}

class _CommunityWriteScreenState extends State<CommunityWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _submitPost() async {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      await ApiService().postBoard(
          _titleController.text, _contentController.text, widget.privateId);
      Navigator.pop(
        context,
        {
          'title': _titleController.text,
          'content': _contentController.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: BackpageWidget(
          beforeContext: context,
        ),
        actions: [
          MenuWidget(
            id: widget.id,
            privateId: widget.privateId,
          )
        ],
        backgroundColor: const Color(0xff95C461),
        title: const Text(
          "글작성",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                    foregroundColor: Colors.white, // Set text color to white
                  ),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white, // Set text color to white
                  ),
                  child: const Text('등록'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white, // Set text color to white
                  ),
                  child: const Text('목록'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
