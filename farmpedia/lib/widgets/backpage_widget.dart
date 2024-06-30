import 'package:flutter/material.dart';

class BackpageWidget extends StatelessWidget {
  final BuildContext beforeContext;
  const BackpageWidget({super.key, required this.beforeContext});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(beforeContext);
        return false; // 뒤로가기를 직접 처리했으므로 false 반환
      },
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(beforeContext); // 이전 페이지로 돌아가기
        },
      ),
    );
  }
}
