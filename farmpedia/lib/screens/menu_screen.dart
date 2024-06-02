import 'package:farmpedia/screens/community_screen.dart';
import 'package:farmpedia/screens/gpt_screen.dart';
import 'package:farmpedia/screens/method_screen.dart';
import 'package:farmpedia/screens/policy_screen.dart';
import 'package:farmpedia/screens/search_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
          backgroundColor: const Color(0xFF95c452),
          title: const Text(
            "귀농가이드",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 15), // 패딩 추가해서 '메뉴'만 왼쪽으로 이동
                child: Text(
                  "메뉴",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // 시작 라인을 맞추기 위해 추가
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()));
                      },
                      child: const Text(
                        "귀농백과",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GPTScreen()));
                      },
                      child: const Text(
                        "귀농GPT",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MethodScreen()));
                      },
                      child: const Text(
                        "농작물 재배 방법",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PolicyScreen()));
                      },
                      child: const Text(
                        "귀농 정책 및 혜택",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CommunityScreen()));
                      },
                      child: const Text(
                        "커뮤니티",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
