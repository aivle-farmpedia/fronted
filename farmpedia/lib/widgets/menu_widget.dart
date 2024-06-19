import 'package:flutter/material.dart';

import '../screens/menu_screen.dart';

class MenuWidget extends StatelessWidget {
  final String id;
  const MenuWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(id: id),
          ),
        );
        debugPrint("시발 $id");
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
