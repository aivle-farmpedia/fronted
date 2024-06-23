// models/policy_board.dart
class PolicyBoard {
  final int id;
  final String title;

  PolicyBoard({
    required this.id,
    required this.title,
  });

  factory PolicyBoard.fromJson(Map<String, dynamic> json) {
    return PolicyBoard(
      id: json['id'],
      title: json['title'],
    );
  }
}
