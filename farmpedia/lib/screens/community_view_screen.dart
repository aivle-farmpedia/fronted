import 'package:flutter/material.dart';

class CommunityViewScreen extends StatelessWidget {
  const CommunityViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu button press
            },
          ),
        ],
        backgroundColor: const Color(0xff95C461),
        title: const Text(
          "커뮤니티",
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
            const SizedBox(height: 16.0),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '대전은 뭐가 유명한가요?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '잘아시는분 계신가요?',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16.0),
                    Divider(),
                    Text(
                      '댓글(3)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    CommentWidget(author: '익명1', content: '한화이글스요'),
                    CommentWidget(author: '익명2', content: '성심당이요'),
                    CommentWidget(author: '익명3', content: '꿈돌이'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle 수정 button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300],
                  ),
                  child: const Text('수정'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('목록'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 삭제 button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String author;
  final String content;

  const CommentWidget({
    super.key,
    required this.author,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$author: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}
