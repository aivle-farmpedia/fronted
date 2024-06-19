import 'dart:convert';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GPTScreen extends StatefulWidget {
  final String id;
  const GPTScreen({super.key, required this.id});

  @override
  State<GPTScreen> createState() => _GPTScreenState();
}

class _GPTScreenState extends State<GPTScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  bool onTextField = false;
  bool isLoading = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        onTextField = searchController.text.isNotEmpty;
      });
    });
  }

  // api만 잘 받아오면 gpt 끝
  Future<String> fetchGPTResponse(String message) async {
    const apiKey = 'OPENAI_API_KEY'; // OpenAI API 키를 여기에 입력하세요
    const url = 'https://api.openai.com/v1/engines/davinci-codex/completions';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt': message,
        'max_tokens': 100,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to load response from OpenAI');
    }
  }

  void sendMessage() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        // text : 내용, isUser: 사용자인지 gpt인지 판별
        messages.add({'text': searchController.text, 'isUser': true});
        isLoading = true;
        searchController.clear();
        onTextField = false;
      });

      try {
        final response = await fetchGPTResponse(messages.last['text']);
        setState(() {
          messages.add({'text': response, 'isUser': false});
        });
      } catch (error) {
        setState(() {
          messages.add({'text': 'Error: ${error.toString()}', 'isUser': false});
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildMessage(String message, bool isUserMessage) {
    return Align(
      // 사용자가 보내면 오른쪽, gpt가 보낸거면 왼쪽
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
          style: const TextStyle(fontSize: 16),
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
          actions: [MenuWidget(id: widget.id)],
          backgroundColor: const Color(0xff95C461),
          title: const Text(
            "귀농GPT",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isUserMessage = messages[index]['isUser'];
                    return buildMessage(messages[index]['text'], isUserMessage);
                  },
                ),
              ),
              if (isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: '입력하세요',
                        suffixIcon: onTextField
                            ? IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: sendMessage,
                              )
                            : const SizedBox(),
                        border: const OutlineInputBorder(),
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
