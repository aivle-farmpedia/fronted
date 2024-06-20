import 'package:flutter/material.dart';
import 'package:farmpedia/services/api_service.dart';
import 'package:farmpedia/screens/community_write_screen.dart';
import 'package:farmpedia/screens/community_view_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';

import '../models/board_model.dart';

class CommunityScreen extends StatefulWidget {
  final String id;
  const CommunityScreen({super.key, required this.id});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<List<Board>> futureBoards;

  @override
  void initState() {
    super.initState();
    futureBoards = fetchBoards();
  }

  Future<List<Board>> fetchBoards() async {
    try {
      List<Board> fetchedBoards = await ApiService().getBoardList(widget.id);
      fetchedBoards.sort((a, b) => b.updatedAt
          .compareTo(a.updatedAt)); // Sort by updatedAt in descending order
      return fetchedBoards;
    } catch (e) {
      throw Exception('Failed to load boards');
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
                      futureBoards =
                          fetchBoards(); // Re-fetch the boards to include the new one
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
                child: FutureBuilder<List<Board>>(
                  future: futureBoards,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No boards available'));
                    } else {
                      final boards = snapshot.data!;
                      return ListView.builder(
                        itemCount: boards.length,
                        itemBuilder: (context, index) {
                          final board = boards[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityViewScreen(
                                    title: board.title,
                                    content: board.content,
                                  ),
                                ),
                              );
                            },
                            child: PostCard(
                              title: board.title,
                              content: board.content,
                            ),
                          );
                        },
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

class PostCard extends StatelessWidget {
  final String title;
  final String content;

  const PostCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '익명의 농부',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
