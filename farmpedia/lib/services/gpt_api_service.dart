import 'dart:convert';

import 'package:farmpedia/models/chat_room_messages_model.dart';
import 'package:farmpedia/models/chat_rooms_list_model.dart';
import 'package:flutter/material.dart';

import '../models/chat_room_id.model.dart';
import '../urls/urls.dart';
import 'package:http/http.dart' as http;

class GPTApiService {
  final baseurl = Urls().uuidBaseUrl();

  // 채팅창 생성
  Future<ChatRoomId> postNewChat(String id) async {
    final url = Uri.parse("${baseurl}api/chat-bot/chat-rooms");
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
    debugPrint("어떻게 나오는지 봅시다 ${response.statusCode.toString()}");
    if (response.statusCode == 201) {
      debugPrint("create 채팅");

      final body = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonData = jsonDecode(body);

      return ChatRoomId.fromJson(jsonData);
    } else {
      throw Exception('Failed to load chat rooms');
    }
  }

  // 챗봇 질문 -> response가 어떻게 오는지 모르겠음
  Future<bool> postChatBotMessage(
      String id, String message, int chatRoomId) async {
    final url =
        Uri.parse("${baseurl}api/chat-bot/chat-rooms/$chatRoomId/messages");
    final Map<String, dynamic> params = {
      'message': message,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
      body: json.encode(params),
    );
    // response가 200 나오긴하는데 챗봇이 대답한 answer는 어디 있는거야?
    if (response.statusCode == 200) {
      debugPrint("postChatBotMessage 성공");

      return true;
    } else {
      return false;
    }
  }

  // 내 전체 채팅 목록
  Future<List<ChatRoomsList>> getChatRooms(String id) async {
    final url = Uri.parse("${baseurl}api/chat-bot/chat-rooms");
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
    debugPrint("어떻게 나오는지 봅시다 ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      debugPrint("getChatRooms 성공 $body");

      List<dynamic> jsonData = jsonDecode(body);
      List<ChatRoomsList> chatRoomList =
          jsonData.map((json) => ChatRoomsList.fromJson(json)).toList();

      return chatRoomList;
    } else {
      throw Exception('Failed to load chat rooms');
    }
  }

  // 하나의 채팅 목록에 대한 전체 채팅 목록
  Future<List<ChatRoomMessages>> getChatBotMessage(
      String id, int chatRoomId) async {
    final url =
        Uri.parse("${baseurl}api/chat-bot/chat-rooms/$chatRoomId/messages");
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
    debugPrint("어떻게 나오는지 봅시다 ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      debugPrint("getChatBotMessage 성공 $body");
      List<dynamic> jsonData = jsonDecode(body);
      List<ChatRoomMessages> chatRoomMessages =
          jsonData.map((json) => ChatRoomMessages.fromJson(json)).toList();
      return chatRoomMessages;
    } else {
      throw Exception('Failed to load crop info');
    }
  }

  // 내 채팅 기록 삭제
  Future<bool> deleteChat(String id, int chatRoomId) async {
    final url = Uri.parse("${baseurl}api/chat-bot/chat-rooms/$chatRoomId");
    debugPrint("url: $url");
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
    debugPrint("어떻게 나오는지 봅시다 ${response.statusCode.toString()}");
    if (response.statusCode == 204) {
      debugPrint("delete 채팅 기록");
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postSelect(String id, String name) async {
    final url = Uri.parse("${baseurl}api/search/select");
    final Map<String, dynamic> params = {'name': name};
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
      body: json.encode(params),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
