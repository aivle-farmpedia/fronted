import 'package:farmpedia/screens/gpt_chat_screen.dart';
import 'package:farmpedia/widgets/build_chat_room_list_widget.dart';
import 'package:flutter/material.dart';

import '../models/chat_rooms_list_model.dart';
import '../services/gpt_api_service.dart';
import '../widgets/backpage_widget.dart';
import '../widgets/menu_widget.dart';

class GptChatListScreen extends StatefulWidget {
  final String id;
  final int privateId;
  const GptChatListScreen({
    super.key,
    required this.id,
    required this.privateId,
  });

  @override
  State<GptChatListScreen> createState() => _GptChatListState();
}

class _GptChatListState extends State<GptChatListScreen> {
  bool isCreateNewChat = false;
  late Future<List<ChatRoomsList>> futureChatLists;

  Future<bool> fetchNewChat(String id) async {
    bool result = await GPTApiService().postNewChat(id);
    debugPrint(isCreateNewChat.toString());
    setState(() {
      isCreateNewChat = result;
    });
    return isCreateNewChat;
  }

  Future<List<ChatRoomsList>> fetchChatList(String id) async {
    try {
      List<ChatRoomsList> fetchedData = await GPTApiService().getChatRooms(id);
      debugPrint("에렁뜨나요? $fetchedData");
      return fetchedData;
    } catch (e) {
      throw Exception('Failed to load boards');
    }
  }

  @override
  void initState() {
    super.initState();
    futureChatLists = fetchChatList(widget.id);
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
          actions: [
            MenuWidget(
              id: widget.id,
              privateId: widget.privateId,
            )
          ],
          backgroundColor: const Color(0xff95C461),
          title: const Text(
            "GPT 채팅 목록",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: FutureBuilder<List<ChatRoomsList>>(
          future: futureChatLists,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              debugPrint("Error: ${snapshot.error}");
              return const Center(child: Text('Failed to load chat rooms'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No chat rooms available'));
            } else {
              final chatRooms = snapshot.data!;
              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  return BuildChatRoomList(
                    id: widget.id,
                    chatRoomId: chatRoom.id,
                    chatRoom: chatRoom,
                    privateId: widget.privateId,
                    reLoadFunc: () {
                      setState(() {
                        futureChatLists = fetchChatList(widget.id);
                      });
                    },
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GPTChatScreen(
                  id: widget.id,
                  privateId: widget.privateId,
                  chatRoomId: 100,
                ),
              ),
            ).then((_) {
              // Reload futureChatLists when returning to this screen
              setState(() {
                futureChatLists = fetchChatList(widget.id);
              });
            });
          },
          backgroundColor: const Color(0xff95C461),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
