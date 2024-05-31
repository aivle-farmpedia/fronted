import 'package:flutter/material.dart';

class ExampleScreen extends StatelessWidget {
  final String title;

  const ExampleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title 페이지입니다.'),
      ),
    );
  }
}
