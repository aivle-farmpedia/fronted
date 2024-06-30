import 'package:farmpedia/services/image_services.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../widgets/custom_pagebar_widget.dart';
import 'home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  final Color mainColor = const Color(0xff95C461);
  final Color barColor = const Color(0xffF1F1F1);
  final uuid = const Uuid();
  late final Future<List<String>> images;

  late PageController _pageViewController;
  late TabController _tabController;
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = uuid.v4();
    _pageViewController = PageController();
    images = ImageService.getImageList();
    images.then((imagePaths) {
      setState(() {
        _tabController = TabController(length: imagePaths.length, vsync: this);
      });
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: imageList(images),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          privateId: userId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '시작하기',
                            style: TextStyle(
                              fontFamily: 'GmarketSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder imageList(Future<List<String>> images) {
    final List<String> words = [
      '귀농백과',
      '정책이나 혜택\n 한눈에 알아보기',
      'GPT에게 물어봐!',
      '귀농을 향한 첫 발걸음'
    ];
    final List<String> stances = [
      '다양한 농사 지식을 습득하세요\n 초보 농부를 위한 앱',
      '쉽고 간편하게',
      '귀농 지피티가 여러분의 궁금점을\n 해결해드릴게요',
      '귀농백과에서 다 알려드립니다!'
    ];

    return FutureBuilder(
      future: images,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<String> imagePaths = snapshot.data ?? [];
        if (_tabController.length != imagePaths.length) {
          _tabController =
              TabController(length: imagePaths.length, vsync: this);
        }

        return pageList(imagePaths, words, stances);
      },
    );
  }

  Column pageList(
      List<String> imagePaths, List<String> words, List<String> stances) {
    return Column(
      children: [
        CustomPagebar(
          controller: _tabController,
          nonSelectedColor: barColor,
          selectedColor: mainColor,
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageViewController,
            onPageChanged: (index) {
              setState(() {
                _tabController.animateTo(index);
              });
            },
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePaths[index],
                      height: 300,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      words[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'GmarketSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      stances[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'GmarketSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
