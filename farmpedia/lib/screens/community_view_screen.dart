import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmpedia/services/api_service.dart';

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
  final List<String> _commentIds = [];
  final List<List<String>> _replies = [];
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  int _replyIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final comments = prefs.getStringList('comments_${widget.title}') ?? [];
    final commentIds = prefs.getStringList('commentIds_${widget.title}') ?? [];

    // 댓글과 댓글 ID의 길이가 일치하는지 확인
    if (comments.length != commentIds.length) {
      debugPrint("Comments and Comment IDs length mismatch!");
      // 데이터 일관성을 보장하기 위해 댓글과 댓글 ID 리스트를 조정할 필요가 있습니다.
      // 여기서는 일치하지 않는 경우 모두 비우는 방법을 사용합니다.
      setState(() {
        _comments.clear();
        _commentIds.clear();
        _replies.clear();
      });
      await prefs.remove('comments_${widget.title}');
      await prefs.remove('commentIds_${widget.title}');
    } else {
      setState(() {
        _comments.addAll(comments);
        _commentIds.addAll(commentIds);
        _replies.addAll(List.generate(comments.length, (index) => []));
      });

      for (int i = 0; i < comments.length; i++) {
        final replies = prefs.getStringList('replies_${widget.title}_$i') ?? [];
        setState(() {
          _replies[i] = replies;
        });
      }
    }

    // 디버깅: 로드된 댓글과 답글 목록 출력
    debugPrint("Loaded comments: $_comments");
    debugPrint("Loaded comment IDs: $_commentIds");
    debugPrint("Loaded replies: $_replies");
  }

  Future<void> _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('comments_${widget.title}', _comments);
    await prefs.setStringList('commentIds_${widget.title}', _commentIds);
    await Future.wait(_comments.asMap().entries.map((entry) {
      int i = entry.key;
      return prefs.setStringList('replies_${widget.title}_$i', _replies[i]);
    }));

    // 디버깅: 저장된 댓글과 답글 목록 출력
    debugPrint("Saved comments: $_comments");
    debugPrint("Saved comment IDs: $_commentIds");
    debugPrint("Saved replies: $_replies");
  }

  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      try {
        String commentId = await ApiService().postComment(
          _commentController.text,
          widget.boardId,
          widget.id,
        );
        setState(() {
          _comments.add(_commentController.text);
          _commentIds.add(commentId);
          _replies.add([]);
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

  void _showReplyInput(int index) {
    setState(() {
      _replyIndex = index;
      _replyController.clear();
    });
  }

  void _addReply(int commentIndex) async {
    if (_replyController.text.isNotEmpty) {
      try {
        // 디버깅: 현재 상태 출력
        debugPrint("Current replies length: ${_replies.length}");
        debugPrint("Attempting to add reply at index: $commentIndex");

        // 부모 댓글 ID를 얻어오기
        String parentId = _commentIds[commentIndex];

        // API 호출하여 답글 전송
        await ApiService().postReply(
          _replyController.text,
          widget.boardId,
          widget.id,
          parentId,
        );

        setState(() {
          // _replies 리스트가 commentIndex까지 존재하는지 확인하고, 없으면 빈 리스트를 추가
          while (_replies.length <= commentIndex) {
            debugPrint(
                "Expanding _replies list: Current length = ${_replies.length}");
            _replies.add([]);
          }

          // 답글 추가
          _replies[commentIndex].add(_replyController.text);
          _replyController.clear();
          _replyIndex = -1;
        });

        debugPrint("Reply added successfully to index $commentIndex");
        _saveComments(); // 답글 저장
      } catch (e) {
        debugPrint("Failed to post reply: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post reply: $e')),
        );
      }
    }
  }

  void _showEditDialog(int index) {
    final TextEditingController editCommentController = TextEditingController();
    editCommentController.text = _comments[index];
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
              onPressed: () {
                _editComment(index, editCommentController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editComment(int index, String newComment) async {
    try {
      await ApiService().editComment(
        newComment,
        widget.boardId,
        widget.id,
        _commentIds[index],
      );
      setState(() {
        _comments[index] = newComment;
      });
      _saveComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to edit comment: $e')),
      );
    }
  }

  void _deleteComment(int index) async {
    try {
      await ApiService().deleteComment(
        widget.boardId,
        widget.id,
        _commentIds[index],
      );
      setState(() {
        _comments.removeAt(index);
        _commentIds.removeAt(index); // 댓글 ID도 함께 제거
        _replies.removeAt(index);
      });
      _saveComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete comment: $e')),
      );
    }
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
                _showEditDialog(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제'),
              onTap: () {
                Navigator.pop(context);
                _deleteComment(index);
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
                                Expanded(child: Text(_comments[index])),
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
                                _showReplyInput(index);
                              },
                              child: const Text(
                                '답글',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            if (_replyIndex == index)
                              TextField(
                                controller: _replyController,
                                decoration: InputDecoration(
                                  labelText: '답글을 입력하세요',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onSubmitted: (value) => _addReply(index),
                              ),
                          ],
                        ),
                      ),
                      ..._replies[index].map((reply) => Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 4.0),
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
