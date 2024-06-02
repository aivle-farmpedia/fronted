import 'package:flutter/material.dart';

import '../screens/menu_screen.dart';

class MeunWidget extends StatelessWidget {
  const MeunWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
