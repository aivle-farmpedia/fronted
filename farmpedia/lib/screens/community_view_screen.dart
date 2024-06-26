import 'package:farmpedia/services/comment_api_service.dart';
import 'package:farmpedia/widgets/comment_widget.dart';
import 'package:flutter/material.dart';

class CommunityViewScreen extends StatefulWidget {
  final String title;
  final String content;
  final int boardId;
  final int id;
  final String privateId;

  const CommunityViewScreen({
    super.key,
    required this.title,
    required this.content,
    required this.boardId,
    required this.id,
    required this.privateId,
  });

  @override
  _CommunityViewScreenState createState() => _CommunityViewScreenState();
}

class _CommunityViewScreenState extends State<CommunityViewScreen> {
  late List<String> _comments;
  late List<String> _commentIds;
  late List<List<String>> _replies;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  int _replyIndex = -1;

  @override
  void initState() {
    super.initState();
    _comments = [];
    _commentIds = [];
    _replies = [];
  }

  void _addComment(String comment, String commentId) {
    setState(() {
      _comments.add(comment);
      _commentIds.add(commentId);
      _replies.add([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                    fontFamily: 'GmaerketSans',
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
                    fontFamily: 'GmarketSans',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const Text(
                '댓글',
                style: TextStyle(
                    fontFamily: 'GmarketSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: CommentWidget(
                  boardId: widget.boardId,
                  privateId: widget.privateId,
                  id: widget.id,
                  comments: _comments,
                  commentIds: _commentIds,
                  replies: _replies,
                  replyIndex: _replyIndex,
                  replyController: _replyController,
                  commentController: _commentController,
                  showReplyInput: (index) {
                    setState(() {
                      _replyIndex = index;
                      _replyController.clear();
                    });
                  },
                  addReply: (index, reply) {
                    setState(() {
                      _replies[index].add(reply);
                    });
                  },
                  updateState: () {
                    setState(() {});
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
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          try {
                            String commentId =
                                await CommentApiService().postComment(
                              value,
                              widget.boardId,
                              widget.privateId,
                            );
                            _addComment(value, commentId); // 댓글을 추가하는 함수 호출
                            _commentController.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                'Failed to post comment: $e',
                                style: const TextStyle(
                                  fontFamily: 'GmarketSans',
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            );
                          }
                        }
                      },
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
                      fontFamily: 'GmarketSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
