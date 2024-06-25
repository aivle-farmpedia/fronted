import 'package:flutter/material.dart';

// ReplyCommentWidget은 댓글의 답글을 표시하고 관리하는 Stateless 위젯입니다.
class ReplyCommentWidget extends StatelessWidget {
  // 필요한 변수들을 선언합니다.
  final List<String> replies; // 답글 목록
  final TextEditingController replyController; // 답글 입력 필드를 제어하는 컨트롤러
  final int replyIndex; // 현재 답글을 입력 중인 댓글의 인덱스
  final Function(int) showReplyInput; // 답글 입력 필드를 표시하는 함수
  final Function(int, String) addReply; // 답글을 추가하는 함수
  final Function(int) deleteReply; // 답글을 삭제하는 함수
  final Function(int) editReply; // 답글을 수정하는 함수

  const ReplyCommentWidget({
    super.key,
    required this.replies,
    required this.replyController,
    required this.replyIndex,
    required this.showReplyInput,
    required this.addReply,
    required this.deleteReply,
    required this.editReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 답글 목록을 순회하며 각 답글을 화면에 표시합니다.
        ...replies.asMap().entries.map((entry) {
          int index = entry.key; // 답글의 인덱스
          String reply = entry.value; // 답글 내용
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 답글 내용이 담긴 컨테이너
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(reply),
                  ),
                ),
                // 답글에 대한 수정, 삭제, 취소 기능을 제공하는 팝업 메뉴 버튼
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    switch (value) {
                      case 'edit':
                        editReply(index); // 답글 수정 함수 호출
                        break;
                      case 'delete':
                        deleteReply(index); // 답글 삭제 함수 호출
                        break;
                      case 'cancel':
                        showReplyInput(-1); // 답글 입력 필드 숨김
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('수정'), // 수정 메뉴 항목
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('삭제'), // 삭제 메뉴 항목
                    ),
                    const PopupMenuItem<String>(
                      value: 'cancel',
                      child: Text('취소'), // 취소 메뉴 항목
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        // 현재 답글을 입력 중인 댓글의 인덱스가 유효한 경우 입력 필드를 표시합니다.
        if (replyIndex != -1)
          TextField(
            controller: replyController, // 입력 필드의 컨트롤러
            decoration: InputDecoration(
              labelText: '답글을 입력하세요', // 입력 필드의 라벨
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), // 입력 필드의 테두리 모양
              ),
            ),
            onSubmitted: (value) =>
                addReply(replyIndex, value), // 답글 입력 후 호출되는 콜백 함수
          ),
      ],
    );
  }
}
