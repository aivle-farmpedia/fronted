import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmpedia/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentWidget extends StatefulWidget {
  final int boardId;
  final String userId;
  final List<String> comments;
  final List<String> commentIds;
  final List<List<String>> replies;
  final int replyIndex;
  final TextEditingController replyController;
  final TextEditingController commentController;
  final Function(int) showReplyInput;
  final Function(int, String) addReply;
  final Function updateState;

  const CommentWidget({
    super.key,
    required this.boardId,
    required this.userId,
    required this.comments,
    required this.commentIds,
    required this.replies,
    required this.replyIndex,
    required this.replyController,
    required this.commentController,
    required this.showReplyInput,
    required this.addReply,
    required this.updateState,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final url = Uri.parse(
          "http://dev.farmpedia.site/api/comments/board/${widget.boardId}");
      debugPrint('Request URL: $url');
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': widget.userId,
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        // 댓글과 댓글 ID 저장
        final List<String> comments = [];
        final List<String> commentIds = [];
        for (var comment in responseData) {
          comments.add(comment['content']);
          commentIds.add(comment['id'].toString());
        }

        setState(() {
          widget.comments.clear();
          widget.commentIds.clear();
          widget.replies.clear();

          widget.comments.addAll(comments);
          widget.commentIds.addAll(commentIds);
          widget.replies.addAll(List.generate(comments.length, (index) => []));
        });
      } else {
        debugPrint("Failed to load comments from server");
      }
    } catch (e) {
      debugPrint("Error fetching comments: $e");
    }
  }

  Future<void> _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('comments_${widget.boardId}', widget.comments);
    await prefs.setStringList(
        'commentIds_${widget.boardId}', widget.commentIds);
    await Future.wait(widget.comments.asMap().entries.map((entry) {
      int i = entry.key;
      debugPrint("Saving replies for comment $i: ${widget.replies[i]}");
      return prefs.setStringList(
          'replies_${widget.boardId}_$i', widget.replies[i]);
    }));
  }

  void _addComment(String comment, String commentId) {
    setState(() {
      widget.comments.add(comment);
      widget.commentIds.add(commentId);
      widget.replies.add([]);
    });
    _saveComments();
  }

  void _editComment(int index, String newComment) {
    setState(() {
      widget.comments[index] = newComment;
    });
    _saveComments();
  }

  void _deleteComment(int index) {
    setState(() {
      widget.comments.removeAt(index);
      widget.commentIds.removeAt(index);
      widget.replies.removeAt(index);
    });
    _saveComments();
  }

  void _showEditDialog(BuildContext context, int index) {
    final TextEditingController editCommentController = TextEditingController();
    editCommentController.text = widget.comments[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('댓글 수정'),
          content: TextField(
            controller: editCommentController,
            decoration: const InputDecoration(labelText: '수정할 댓글 내용'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () async {
                try {
                  await ApiService().editComment(
                    editCommentController.text,
                    widget.boardId,
                    widget.userId,
                    widget.commentIds[index],
                  );
                  _editComment(index, editCommentController.text);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to edit comment: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('수정'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context, index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await ApiService().deleteComment(
                    widget.boardId,
                    widget.userId,
                    widget.commentIds[index],
                  );
                  _deleteComment(index);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete comment: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('취소'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(widget.comments[index])),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showOptions(context, index);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {
                      widget.showReplyInput(index);
                    },
                    child: const Text(
                      '답글',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  if (widget.replyIndex == index)
                    TextField(
                      controller: widget.replyController,
                      decoration: InputDecoration(
                        labelText: '답글을 입력하세요',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          try {
                            String parentId = widget.commentIds[index];
                            await ApiService().postReply(
                              value,
                              widget.boardId,
                              widget.userId,
                              parentId,
                            );
                            widget.addReply(index, value);
                            widget.replyController.clear();
                            widget.updateState();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Failed to post reply: $e')),
                            );
                          }
                        }
                      },
                    ),
                ],
              ),
            ),
            ...widget.replies[index].map((reply) => Padding(
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
          ],
        );
      },
    );
  }
}
