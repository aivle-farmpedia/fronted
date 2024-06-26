import 'package:farmpedia/widgets/paging_widget.dart';
import 'package:flutter/material.dart';
import 'package:farmpedia/services/api_service.dart';
import 'package:farmpedia/screens/community_write_screen.dart';
import 'package:farmpedia/screens/community_view_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';

import '../models/board_model.dart';
import '../widgets/postcard_widget.dart';

class CommunityScreen extends StatefulWidget {
  final int id;
  final String privateId;
  const CommunityScreen({super.key, required this.id, required this.privateId});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<Map<String, dynamic>> futureBoards;
  int currentPage = 1;
  bool isLoadingMore = false;
  List<Board> allBoards = [];
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    futureBoards = fetchBoards(currentPage);
    debugPrint(widget.privateId.toString());
  }

  void _onPageChange(int page) {
    setState(() {
      futureBoards = fetchBoards(page);
      allBoards.clear(); // Clear allBoards when page changes
    });
  }

  Future<Map<String, dynamic>> fetchBoards(int page) async {
    try {
      Map<String, dynamic> fetchedData =
          await ApiService().getBoardList(widget.privateId, page);
      setState(() {
        totalPages = fetchedData['totalPages'];
      });
      return fetchedData;
    } catch (e) {
      throw Exception('Failed to load boards');
    }
  }

  // void loadMoreBoards() async {
  //   if (!isLoadingMore && currentPage < totalPages) {
  //     setState(() {
  //       isLoadingMore = true;
  //     });
  //     currentPage++;
  //     Map<String, dynamic> newBoards = await fetchBoards(currentPage);
  //     setState(() {
  //       allBoards.addAll(newBoards['boards']);
  //       isLoadingMore = false;
  //     });
  //   }
  // }

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
          actions: [
            MenuWidget(
              id: widget.id,
              privateId: widget.privateId,
            )
          ],
          backgroundColor: const Color(0xff95C461),
          title: const Text(
            "커뮤니티",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'GmarketSans',
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
                      builder: (context) => CommunityWriteScreen(
                        id: widget.id,
                        privateId: widget.privateId,
                      ),
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
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GmarketSans',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: futureBoards,
                  builder: (context, snapshot) {
                    // 데이터 로딩 중이면 로딩 아이콘 띄우기
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // 데이터 로딩 중 에러떴을 때 에러 메세지 띄움
                    else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // 불러온 데이터가 없거나 게시물이 없을 때는 메세지 띄움
                    else if (!snapshot.hasData ||
                        snapshot.data!['boards'].isEmpty) {
                      return const Center(child: Text('No boards available'));
                    }
                    // 데이터가 성공적으로 로드됐을 때
                    else {
                      // 불러온 게시물 데이터를 allBoards에 저장한다
                      allBoards.addAll(snapshot.data!['boards']);
                      // NotificationListener<ScrollNotification> : 스크롤 이벤트 감지함
                      return NotificationListener<ScrollNotification>(
                        // onNotification : 스크롤 이벤트 발생 했을 때 실행되는 함수
                        onNotification: (scrollNotification) {
                          // 스크롤 가능할 때까지 하고, 현재 페이지가 총 페이지보다 작을 때 데이터 로드
                          if (scrollNotification is ScrollEndNotification &&
                              scrollNotification.metrics.pixels ==
                                  scrollNotification.metrics.maxScrollExtent &&
                              currentPage < totalPages) {
                            // loadMoreBoards();
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
                                      privateId: widget.privateId,
                                    ),
                                  ),
                                );
                              },
                              child: PostCard(
                                title: board.title,
                                content: board.content,
                                boardId: board.id,
                                id: widget.id,
                                boardUserId: board.userId,
                                privateId: widget.privateId,
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
              const SizedBox(height: 16),
              PagingWidget(
                totalPages: totalPages,
                onPageChange: _onPageChange,
              )
            ],
          ),
        ),
      ),
    );
  }
}
