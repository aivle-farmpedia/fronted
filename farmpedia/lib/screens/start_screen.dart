import 'package:farmpedia/services/image_services.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  final Color mainColor = const Color(0xff95C461);
  late final Future<List<String>> images;

  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    images = ImageSerivce.getImageList();
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    child: Text(
                      '시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
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

        return Column(
          children: [
            TabPageSelector(
              controller: _tabController,
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
      },
    );
  }
}
