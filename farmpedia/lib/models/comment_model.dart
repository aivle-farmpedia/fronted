class CommentModel {
  final int id;
  final String title;
  final String content;
  final int userId;
  final int state;
  final int parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.state,
    required this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      userId: json['userId'],
      state: json['state'],
      parentId: json['parentId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
