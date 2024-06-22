import 'package:flutter/material.dart';
import 'package:farmpedia/services/api_service.dart';
import 'package:farmpedia/screens/community_write_screen.dart';
import 'package:farmpedia/screens/community_view_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';

import '../models/board_model.dart';
import '../widgets/postcard_widget.dart';

class CommunityScreen extends StatefulWidget {
  final String id;
  const CommunityScreen({super.key, required this.id});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<Map<String, dynamic>> futureBoards;
  int currentPage = 1;
  final int pageSize = 10;
  bool isLoadingMore = false;
  List<Board> allBoards = [];
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    futureBoards = fetchBoards(currentPage);
  }

  Future<Map<String, dynamic>> fetchBoards(int page) async {
    try {
      Map<String, dynamic> fetchedData =
          await ApiService().getBoardList(widget.id, page);
      setState(() {
        totalPages = fetchedData['totalPages'];
      });
      return fetchedData;
    } catch (e) {
      throw Exception('Failed to load boards');
    }
  }

  void loadMoreBoards() async {
    if (!isLoadingMore && currentPage < totalPages) {
      setState(() {
        isLoadingMore = true;
      });
      currentPage++;
      Map<String, dynamic> newBoards = await fetchBoards(currentPage);
      setState(() {
        allBoards.addAll(newBoards['boards']);
        isLoadingMore = false;
      });
    }
  }

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
          actions: [MenuWidget(id: widget.id)],
          backgroundColor: const Color(0xff95C461),
          title: const Text(
            "커뮤니티",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityWriteScreen(id: widget.id),
                    ),
                  );

                  if (result != null && mounted) {
                    setState(() {
                      futureBoards = fetchBoards(1);
                      currentPage = 1;
                      allBoards.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  '글쓰기',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: futureBoards,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        snapshot.data!['boards'].isEmpty) {
                      return const Center(child: Text('No boards available'));
                    } else {
                      allBoards.addAll(snapshot.data!['boards']);
                      return NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification &&
                              scrollNotification.metrics.pixels ==
                                  scrollNotification.metrics.maxScrollExtent &&
                              currentPage < totalPages) {
                            loadMoreBoards();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          itemCount: allBoards.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == allBoards.length) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final board = allBoards[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommunityViewScreen(
                                      title: board.title,
                                      content: board.content,
                                      boardId: board.id,
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: PostCard(
                                title: board.title,
                                content: board.content,
                                boardId: board.id,
                                id: widget.id,
                                onDelete: () {
                                  setState(() {
                                    futureBoards = fetchBoards(1);
                                    currentPage = 1;
                                    allBoards.clear();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
