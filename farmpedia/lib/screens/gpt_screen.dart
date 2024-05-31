import 'package:farmpedia/screens/menu_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:flutter/material.dart';

class GPTScreen extends StatelessWidget {
  const GPTScreen({super.key});

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
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Icon(
                  Icons.menu,
                  size: 30.0,
                ),
              ),
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          title: const Text(
            "귀농GPT",
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
