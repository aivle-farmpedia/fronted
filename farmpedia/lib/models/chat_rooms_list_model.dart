class ChatRoomsList {
  final int id;
  final int userId;
  final String recentMsg;
  final DateTime createdAt;
  final bool deleted;

  ChatRoomsList({
    required this.id,
    required this.userId,
    required this.recentMsg,
    required this.createdAt,
    required this.deleted,
  });

  factory ChatRoomsList.fromJson(Map<String, dynamic> json) {
    return ChatRoomsList(
      id: json['id'],
      userId: json['userId'],
      recentMsg: json['recentMsg'],
      createdAt: DateTime.parse(json['createdAt']),
      deleted: json['deleted'],
    );
  }
}
