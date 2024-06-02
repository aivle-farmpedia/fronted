import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class MethodScreen extends StatelessWidget {
  const MethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: BackpageWidget(
            beforeContext: context,
          ),
          actions: const [MenuWidget()],
          backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          title: const Text(
            "농작물 재배 방법",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
