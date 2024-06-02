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
    // 유저의 개인 Id 생성
    userId = uuid.v4();
    // PageView 위젯 제어하는데 사용
    _pageViewController = PageController();
    // images/ 아래에 있는 이미지들을 불어롬
    images = ImageService.getImageList();
    // 이미지 파일들 로드 하면 실행
    images.then((imagePaths) {
      // 상태가 변경되면 반영
      setState(() {
        // 전체 이미지 목록 길이,
        // 현재 상태 객체(vsync:this -> 무슨 소리냐 현재 몇 번째 이미지 목록인지) 전달
        _tabController = TabController(length: imagePaths.length, vsync: this);
      });
    });
  }

  // 간단하게 위의 페이지 표시 바에서 사용하지 않는 페이지들에 초록불이 안들어 오도록 만들어주는거 같음
  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // 시작하기 버튼 누르면 페이지 이동(HomeScreen)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // HomeScreen 으로 이동할 때 생성한 userId HomeScreen 으로 넘겨줌
                      builder: (context) => HomeScreen(
                        id: userId,
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
    );
  }

  FutureBuilder imageList(Future<List<String>> images) {
    final List<String> words = ['귀농백과1', '샤넬이 사진'];
    final List<String> stances = ['다양한 농사 지식을 습득하세요\n 초보 농부를 위한 앱', '샤넬이 귀여워'];

    return FutureBuilder(
      future: images,
      builder: (context, snapshot) {
        // 데이터 로드가 안되면 로딩아이콘 보여줌
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

  // 페이지별로 화면에 보여주는 이미지들이 다른걸 구현한 것
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
          // 이미지 목록들을 보여준다
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
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
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
