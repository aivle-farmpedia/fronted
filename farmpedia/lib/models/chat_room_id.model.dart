class ChatRoomId {
  final int id;

  ChatRoomId({required this.id});

  factory ChatRoomId.fromJson(Map<String, dynamic> json) {
    return ChatRoomId(
      id: json['id'],
    );
  }
}
