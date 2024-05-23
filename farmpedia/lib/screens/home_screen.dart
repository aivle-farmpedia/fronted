import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('귀농백과'),
        ),
        body: const Center(
          child: Column(
            children: [
              Text('HOME'),
            ],
          ),
        ),
      ),
    );
  }
}
