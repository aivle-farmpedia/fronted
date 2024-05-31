import 'package:flutter/material.dart';

class BackpageWidget extends StatelessWidget {
  final BuildContext beforeContext;
  const BackpageWidget({super.key, required this.beforeContext});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(beforeContext); // 이전 페이지로 돌아가기
      },
    );
  }
}
