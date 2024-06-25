import 'package:farmpedia/services/comment_api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentWidget extends StatefulWidget {
  final int boardId;
  final int id;
  final String privateId;
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
    required this.id,
    required this.privateId,
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
  int totalPages = 1;
  late Future<Map<String, dynamic>> futureComment;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    futureComment = loadComments(1);
  }

  Future<Map<String, dynamic>> loadComments(int page) async {
    try {
      Map<String, dynamic> responseData = await CommentApiService()
          .fetchComments(widget.boardId, widget.privateId);
      setState(() {
        totalPages = responseData['totalPages'];
        widget.comments.clear();
        widget.commentIds.clear();
        widget.replies.clear();

        Map<int, List<String>> tempReplies = {};

        for (var comment in responseData['data']) {
          if (comment['parentId'] == null) {
            userId = comment['userId'];
            widget.comments.add(comment['content']);
            widget.commentIds.add(comment['id'].toString());
            widget.replies.add([]);
          } else {
            int parentId = comment['parentId'];
            if (!tempReplies.containsKey(parentId)) {
              tempReplies[parentId] = [];
            }
            tempReplies[parentId]!.add(comment['content']);
          }
        }

        for (int i = 0; i < widget.commentIds.length; i++) {
          int commentId = int.parse(widget.commentIds[i]);
          if (tempReplies.containsKey(commentId)) {
            widget.replies[i] = tempReplies[commentId]!;
          }
        }
      });
      return responseData;
    } catch (e) {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('comments_${widget.boardId}', widget.comments);
    await prefs.setStringList(
        'commentIds_${widget.boardId}', widget.commentIds);
    await Future.wait(widget.comments.asMap().entries.map((entry) {
      int i = entry.key;
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
            // "취소" 버튼: 다이얼로그를 닫습니다.
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // "저장" 버튼: 댓글을 수정하고, 수정된 내용을 서버에 저장합니다.
            TextButton(
              child: const Text('저장'),
              onPressed: () async {
                try {
                  // 서버에 수정된 댓글을 저장합니다.
                  await CommentApiService().editComment(
                    editCommentController.text, // 수정된 댓글 내용
                    widget.privateId, // 사용자 ID
                    widget.commentIds[index], // 댓글 ID
                  );
                  // 로컬 상태를 업데이트합니다.
                  _editComment(index, editCommentController.text);
                  Navigator.of(context).pop(); // 다이얼로그를 닫습니다.
                } catch (e) {
                  // 오류가 발생하면 스낵바를 사용하여 사용자에게 알립니다.
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
                  await CommentApiService().deleteComment(
                    widget.privateId,
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
    return FutureBuilder<Map<String, dynamic>>(
      future: futureComment,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
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
                                if (widget.id == userId) {
                                  _showOptions(context, index);
                                }
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
                                  await CommentApiService().postReply(
                                    value,
                                    widget.boardId,
                                    widget.privateId,
                                    parentId,
                                  );
                                  widget.addReply(index, value);
                                  widget.replyController.clear();
                                  widget.updateState();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to post reply: $e')),
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
        } else {
          return const Center(child: Text('No comments available.'));
        }
      },
    );
  }
}
