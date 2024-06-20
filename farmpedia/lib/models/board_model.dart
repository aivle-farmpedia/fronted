class Board {
  final int id;
  final String title;
  final String content;
  final int userId;
  final int state;
  final DateTime createdAt;
  final DateTime updatedAt;

  Board({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Board from JSON
  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      userId: json['userId'],
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
