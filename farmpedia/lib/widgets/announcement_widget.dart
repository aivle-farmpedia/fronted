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
                fontFamily: 'GmarketSans',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Container(
              height: 20,
            ),
            const Text(
              "농업기계 보유현황 조사",
              style: TextStyle(
                fontFamily: 'GmarketSans',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Container(
              height: 20,
            ),
            const Text(
              "토양개량제 지원사업",
              style: TextStyle(
                fontFamily: 'GmarketSans',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Container(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
