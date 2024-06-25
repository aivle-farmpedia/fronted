import 'package:flutter/material.dart';

import '../screens/menu_screen.dart';

class MenuWidget extends StatelessWidget {
  final int id;
  final String privateId;
  const MenuWidget({super.key, required this.id, required this.privateId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(
              id: id,
              privateId: privateId,
            ),
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
