class ChatRoomMessages {
  final int id;
  final int chatRoomId;
  final String question;
  final String answer;
  final DateTime createdAt;

  ChatRoomMessages({
    required this.id,
    required this.chatRoomId,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  factory ChatRoomMessages.fromJson(Map<String, dynamic> json) {
    return ChatRoomMessages(
      id: json['id'],
      chatRoomId: json['chatRoomId'],
      question: json['question'],
      answer: json['answer'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
