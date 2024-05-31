import 'package:flutter/material.dart';

import '../screens/community_screen.dart';
import '../screens/gpt_screen.dart';
import '../screens/policy_screen.dart';
import '../screens/search_screen.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff31550b),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "메뉴",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.book,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "귀농백과",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PolicyScreen(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "지원정책",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GPTScreen(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "귀농GPT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommunityScreen(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.group,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        "커뮤니티",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
