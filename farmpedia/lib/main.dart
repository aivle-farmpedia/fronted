import 'package:farmpedia/screens/start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartScreen(),
      theme: ThemeData(
        fontFamily: "GmarketSans",
      ),
      themeMode: ThemeMode.system,
    );
  }
}
