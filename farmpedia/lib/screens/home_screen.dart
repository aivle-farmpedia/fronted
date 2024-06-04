import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/home_menu_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/announcement_widget.dart';

class HomeScreen extends StatefulWidget {
  final String id;
  const HomeScreen({super.key, required this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  late List<String> userId;

  final List<String> videoUrls = [
    'https://www.youtube.com/watch?v=eQxuRe2Syh0',
    'https://www.youtube.com/watch?v=eQxuRe2Syh0',
    'https://www.youtube.com/watch?v=KkMRy_Viz-s-s',
    'https://www.youtube.com/watch?v=KkMRy_Viz-s-s',
  ];

  final List<String> imageUrls = [
    'https://i.ytimg.com/vi/ixxhaHU4oN0/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD2YqI1dnQoc8c3jFTO0CWHuhdWLQ',
    'https://i.ytimg.com/vi/_sElN_xue48/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0bhHZDHXyCHjGBrn47oD9imigBQ',
    'https://i.ytimg.com/vi/KkMRy_Viz-s/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA9VZXpG2KWZF1rAMXur1tUGrjUTA',
    'https://i.ytimg.com/vi/KkMRy_Viz-s/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA9VZXpG2KWZF1rAMXur1tUGrjUTA',
  ];

  // 사용자의 개인 Id를 로컬 저장소에 저장한것
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getStringList('userId') ?? [];
    if (userId.isEmpty) {
      userId = [widget.id];
      await prefs.setStringList('userId', userId);
    }
    // userId(uuid) 확인용
    debugPrint("$userId");
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    // const Color mainColor = Color(0xff95C461);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: BackpageWidget(
            beforeContext: context,
          ),
          actions: const [MenuWidget()],
          title: const Text(
            '귀농백과',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                // 길어서 따로 위젯으로 뺌

                const SizedBox(
                  height: 12,
                ),
                const Column(
                  children: [
                    AnnouncementWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    HomeMenuWidget(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff95C461),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("요즘 유행하는 작물 재배"),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("사과"),
                            Text("포도"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200, // 명시적으로 높이 설정
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final url = videoUrls[index];
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.green[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
