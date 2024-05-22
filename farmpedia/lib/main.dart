import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff95C461),
          foregroundColor: Colors.white,
          title: const Text(
            '귀농백과',
            style: TextStyle(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('hello world!!2222'),
              Image.asset("images/main_image1.png"),
            ],
          ),
        ),
      ),
    );
  }
}
