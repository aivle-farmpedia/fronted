import 'package:farmpedia/models/chat_room_messages_model.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

import '../services/gpt_api_service.dart';

class GPTChatScreen extends StatefulWidget {
  final int id;
  final String privateId;
  final int chatRoomId;
  const GPTChatScreen({
    super.key,
    required this.id,
    required this.privateId,
    required this.chatRoomId,
  });

  @override
  State<GPTChatScreen> createState() => _GPTScreenState();
}

class _GPTScreenState extends State<GPTChatScreen> {
  TextEditingController searchController = TextEditingController();
  late Future<List<ChatRoomMessages>> futureChatRoomMessages;
  List<ChatRoomMessages> messages = [];
  bool onTextField = false;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureChatRoomMessages =
        fetchGPTRoomMessage(widget.privateId, widget.chatRoomId);
    futureChatRoomMessages.then((value) {
      setState(() {
        messages = value;
      });
      _scrollToBottom();
    });
    searchController.addListener(() {
      setState(() {
        onTextField = searchController.text.isNotEmpty;
      });
    });
  }

  Future<List<ChatRoomMessages>> fetchGPTRoomMessage(
      String id, int chatRoomId) async {
    try {
      List<ChatRoomMessages> fetchedData =
          await GPTApiService().getChatBotMessage(id, chatRoomId);
      return fetchedData;
    } catch (e) {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> fetchGPTResponse(
      String id, String message, int chatRoomId) async {
    try {
      bool result =
          await GPTApiService().postChatBotMessage(id, message, chatRoomId);
      if (result) {
        List<ChatRoomMessages> updatedMessages =
            await GPTApiService().getChatBotMessage(id, chatRoomId);
        setState(() {
          messages = updatedMessages;
          isLoading = false;
        });
        _scrollToBottom(); // Scroll to the bottom after loading new messages
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _scrollToBottom(); // Ensure to scroll to the bottom even if an error occurs
      throw Exception('Failed to send message');
    }
  }

  void sendMessage() async {
    if (searchController.text.isNotEmpty) {
      String userMessage = searchController.text;
      setState(() {
        messages.add(ChatRoomMessages(
          id: 0,
          chatRoomId: widget.chatRoomId,
          question: userMessage,
          answer: '',
          createdAt: DateTime.now(),
        ));
        isLoading = true;
        searchController.clear();
        onTextField = false;
      });

      _scrollToBottom(); // Scroll to the bottom before starting the loading process

      await fetchGPTResponse(widget.privateId, userMessage, widget.chatRoomId);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildMessage(ChatRoomMessages message) {
    bool isUserMessage = message.answer.isEmpty;
    return Column(
      crossAxisAlignment:
          isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (isUserMessage)
          buildBubble(message.question, true)
        else ...[
          buildBubble(message.question, true),
          buildBubble(message.answer, false),
        ],
      ],
    );
  }

  Widget buildBubble(String message, bool isUserMessage) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUserMessage ? const Color(0xFFE0F2CD) : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'GmarketSans',
            fontSize: 16,
          ),
        ),
      ),
    );
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
            "귀농GPT",
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
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return buildMessage(message);
                  },
                ),
              ),
              if (isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      maxLength: null,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: '입력하세요',
                        suffixIcon: onTextField
                            ? IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: sendMessage,
                              )
                            : const SizedBox(),
                        // border: InputBorder.none,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
