import 'package:flutter/cupertino.dart';

class AnnouncementWidget extends StatelessWidget {
  const AnnouncementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffE0F2CD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 25,
        ),
        child: Column(
          children: [
            const Text(
              "지원 정책",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
