import 'package:farmpedia/services/api_service.dart';
import 'package:farmpedia/widgets/home_menu_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/announcement_widget.dart';
import 'search_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String privateId;
  const HomeScreen({super.key, required this.privateId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> userIdFuture;
  late Future<int> privateIdFuture;
  final List<String> videoUrls = [
    'https://youtu.be/bobabgSRMLQ?list=PL-PTrC1baTi9aRW1or_xNE3LRvyoIKk9H',
    'https://youtu.be/ixxhaHU4oN0?list=PL-PTrC1baTi9aRW1or_xNE3LRvyoIKk9H',
    'https://youtu.be/UIWvxS_vCeI?list=PL-PTrC1baTi9aRW1or_xNE3LRvyoIKk9H',
    'https://youtu.be/RlyjggTXWHU?list=PL-PTrC1baTi9aRW1or_xNE3LRvyoIKk9H',
    'https://youtu.be/_sElN_xue48?list=PL-PTrC1baTi9aRW1or_xNE3LRvyoIKk9H',
    'https://youtu.be/KkMRy_Viz-s?list=PL-PTrC1baTi9aRW1or_xNE3LRvyoIKk9H',
  ];

  final List<String> imageUrls = [
    'https://i.ytimg.com/vi/bobabgSRMLQ/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCx5eDMC_HJITkueBdiwXA1SRQ92g',
    'https://i.ytimg.com/vi/ixxhaHU4oN0/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLAt7pY4htycmiUjZgoNFBblQ9u6UQ',
    'https://i.ytimg.com/vi/UIWvxS_vCeI/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLAahUsuTfWExYEJlKI4IuLfntFh8w',
    'https://i.ytimg.com/vi/RlyjggTXWHU/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBDRNnjiLw2S1R4LaTJi1rqv_JSXw',
    'https://i.ytimg.com/vi/_sElN_xue48/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLAAXBc_O4VAMGMO_Lxjxh1lC8zykg',
    'https://i.ytimg.com/vi/KkMRy_Viz-s/hqdefault.jpg?sqp=-oaymwEcCPYBEIoBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBxcP8ZA041mO3JrMP1eQWWqR5pPg',
  ];

  Future<String?> initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    debugPrint(userId);
    if (userId == null) {
      await prefs.setString('userId', widget.privateId);
      userId = widget.privateId;
    } else {
      debugPrint("이미 존재? $userId");
    }
    return userId;
  }

  Future<int> initPrivateId() async {
    final prefs = await SharedPreferences.getInstance();
    int? privateId = prefs.getInt('privateId');

    if (privateId == null) {
      privateId = await ApiService().postUuid(widget.privateId);
      await prefs.setInt('privateId', privateId);
    } else {
      debugPrint("이미 존재 $privateId");
    }
    return privateId;
  }

  Future<void> navigateToSearchDetail(String cropName) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    final privateId = prefs.getInt('privateId') ?? 0;

    // Get cropId from getKeyword API
    final cropItems = await ApiService().getKeyword(userId, cropName);
    final cropId = cropItems.isNotEmpty ? cropItems.first.id : 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchDetailScreen(
          id: privateId,
          privateId: userId,
          crops: cropName,
          cropId: cropId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userIdFuture = initPrefs();
    privateIdFuture = initPrivateId();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            FutureBuilder<String?>(
              future: userIdFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink(); // Placeholder while waiting
                } else if (snapshot.hasError) {
                  return const Icon(
                      Icons.error); // Error icon if there's an error
                } else {
                  final userId = snapshot.data ?? '';
                  return FutureBuilder<int>(
                    future: privateIdFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox
                            .shrink(); // Placeholder while waiting
                      } else if (snapshot.hasError) {
                        return const Icon(
                            Icons.error); // Error icon if there's an error
                      } else {
                        final id = snapshot.data ?? 0;
                        return MenuWidget(
                          id: id,
                          privateId: userId,
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
          centerTitle: true,
          title: const Text(
            '귀농백과',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'GmarketSans',
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<String?>(
          future: userIdFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading userId'));
            } else {
              final privateId = snapshot.data ?? '';
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          const AnnouncementWidget(),
                          const SizedBox(height: 15),
                          FutureBuilder<int>(
                            future: privateIdFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading privateId'));
                              } else {
                                final userId = snapshot.data ?? 0;
                                return HomeMenuWidget(
                                  id: userId,
                                  privateId: privateId,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff95C461),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "요즘 유행하는 작물 재배",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'GmarketSans',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        navigateToSearchDetail("사과"),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.all(Colors.black),
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    child: const Text(
                                      "사과",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GmarketSans',
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        navigateToSearchDetail("포도"),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.all(Colors.black),
                                      overlayColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    child: const Text(
                                      "포도",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GmarketSans',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
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
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
