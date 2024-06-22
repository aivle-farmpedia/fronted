class UserId {
  final int userId;

  UserId({
    required this.userId,
  });

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      userId: json['id'],
    );
  }
}
