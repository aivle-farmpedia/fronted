import 'package:flutter/material.dart';

class BoardContent {
  final int id;
  final String content;
  final DateTime createdAt;

  BoardContent({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  factory BoardContent.fromJson(Map<String, dynamic> json) {
    return BoardContent(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
