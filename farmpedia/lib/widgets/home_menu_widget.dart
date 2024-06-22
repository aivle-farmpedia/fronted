import 'package:flutter/material.dart';

import '../screens/community_screen.dart';
import '../screens/gpt_screen.dart';
import '../screens/policy_screen.dart';
import '../screens/search_screen.dart';

class HomeMenuWidget extends StatefulWidget {
  final String id;
  final int privateId;
  const HomeMenuWidget({
    super.key,
    required this.id,
    required this.privateId,
  });

  @override
  State<HomeMenuWidget> createState() => _HomeMenuWidgetState();
}

class _HomeMenuWidgetState extends State<HomeMenuWidget> {
  @override
  void initState() {
    super.initState();
    String a = widget.id;
    debugPrint("너 이상한놈인데? $a");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff31550b),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                          id: widget.id,
                          privateId: widget.privateId,
                        ),
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
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PolicyScreen(
                          id: widget.id,
                          privateId: widget.privateId,
                        ),
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
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GPTScreen(
                          id: widget.id,
                          privateId: widget.privateId,
                        ),
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
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityScreen(
                          id: widget.id,
                          privateId: widget.privateId,
                        ),
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
                          fontSize: 18,
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
