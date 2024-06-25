import 'package:farmpedia/services/api_service.dart';
import 'package:farmpedia/widgets/home_menu_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/announcement_widget.dart';

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
    'https://www.youtube.com/watch?v=eQxuRe2Syh0',
    'https://www.youtube.com/watch?v=eQxuRe2Syh0',
    'https://www.youtube.com/watch?v=KkMRy_Viz-s',
    'https://www.youtube.com/watch?v=KkMRy_Viz-s',
  ];

  final List<String> imageUrls = [
    'https://i.ytimg.com/vi/ixxhaHU4oN0/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD2YqI1dnQoc8c3jFTO0CWHuhdWLQ',
    'https://i.ytimg.com/vi/_sElN_xue48/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLD0bhHZDHXyCHjGBrn47oD9imigBQ',
    'https://i.ytimg.com/vi/KkMRy_Viz-s/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA9VZXpG2KWZF1rAMXur1tUGrjUTA',
    'https://i.ytimg.com/vi/KkMRy_Viz-s/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA9VZXpG2KWZF1rAMXur1tUGrjUTA',
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
    // prefs.clear();
    int? privateId = prefs.getInt('privateId');

    if (privateId == null) {
      privateId = await ApiService().postUuid(widget.privateId);
      await prefs.setInt('privateId', privateId);
    } else {
      debugPrint("이미 존재 $privateId");
    }
    return privateId;
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
              fontSize: 30,
              fontWeight: FontWeight.w400,
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
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("요즘 유행하는 작물 재배"),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("사과"),
                                  Text("포도"),
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
