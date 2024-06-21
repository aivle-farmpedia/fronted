import 'dart:convert';

// import 'package:farmpedia/models/uuid_model.dart';
import 'package:farmpedia/models/board_content_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/board_model.dart';
import '../urls/urls.dart';

class ApiService {
  final baseurl = Urls().uuidBaseUrl();

  // uuid 저장 -> 최초 접속시
  Future<void> postUuid(String userId) async {
    // String uuidInstance = '';
    final url = Uri.parse("${baseurl}api/auth/save");
    final Map<String, dynamic> params = {'uuid': userId};
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(params),
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 201) {
      debugPrint("성공");
    } else {
      throw Error();
    }
  }

  // 게시글 작성
  Future<void> postBoard(String title, String content, String id) async {
    final url = Uri.parse("${baseurl}api/board");
    final Map<String, dynamic> params = {
      'title': title,
      'content': content,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
      body: json.encode(params),
    );
    if (response.statusCode == 201) {
      debugPrint(utf8.decode(response.bodyBytes));
    } else {
      throw Error;
    }
  }

  // 게시글 전체 조회
  Future<List<Board>> getBoardList(String id) async {
    final url = Uri.parse("${baseurl}api/board");
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
        'Accept-Encoding': 'identity',
      },
    );
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonData = jsonDecode(body);

      // Check if the JSON has the 'boards' key and it is a list
      if (jsonData.containsKey('boards') && jsonData['boards'] is List) {
        List<dynamic> boardsJson = jsonData['boards'];
        List<Board> boards =
            boardsJson.map((json) => Board.fromJson(json)).toList();
        // debugPrint(boardsJson.toString());
        // Debug print to check the boards
        return boards;
      } else {
        throw Exception('Invalid JSON structure');
      }
    } else {
      throw Exception('Failed to load boards');
    }
  }

  // 게시글 수정 -> 수정해야함
  Future<void> putBoard(
      String title, String content, String id, int boardId) async {
    final url = Uri.parse("$baseurl/api/board/$boardId");
    final Map<String, dynamic> params = {
      'title': title,
      'content': content,
    };
    final response = await http.put(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
  }

  // 게시글 삭제 -> 수정
  Future<bool> deleteBoard(String id, int boardId) async {
    final url = Uri.parse("${baseurl}api/board/$boardId");
    final response = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // 댓글 작성 -> API 요청 성공 했는데 이걸
  // return값을 어떻게 사용할지 또 이걸 어떻게 community_screen에 사용하도록 변경 필요
  Future<void> postContent(String content, int boardId, String id) async {
    final url = Uri.parse("${baseurl}api/comment/board/$boardId");

    final body = json.encode({"content": content});
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
      body: body,
    );

    debugPrint(boardId.toString());
    if (response.statusCode == 201) {
      debugPrint("제대로 불러와짐");
    } else {
      throw Error;
    }
  }
}
