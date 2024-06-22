import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/board_model.dart';
import '../urls/urls.dart';

class ApiService {
  final baseurl = Urls().uuidBaseUrl();

  // uuid 저장 -> 최초 접속시
  Future<int> postUuid(String userId) async {
    // String uuidInstance = '';
    final url = Uri.parse("${baseurl}api/auth/save");
    final Map<String, dynamic> params = {'uuid': userId};
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(params),
    );
    // debugPrint(response.statusCode.toString());
    debugPrint("???? ${response.statusCode.toString()}");
    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData['id'];
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
  // 게시글 전체 조회할 때 뭐가 문제가 되냐
  // 이거 페이징 되어있어서 현재 페이지 알아야하고, 마지막페이지 알아야하고,

  Future<Map<String, dynamic>> getBoardList(String id, int page) async {
    final url = Uri.parse("${baseurl}api/board?page=$page");
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
      debugPrint(body);
      if (jsonData.containsKey('data') && jsonData['data'] is List) {
        List<dynamic> boardsJson = jsonData['data'];
        List<Board> boards =
            boardsJson.map((json) => Board.fromJson(json)).toList();
        // boards.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return {
          'boards': boards,
          'page': jsonData['page'],
          'size': jsonData['size'],
          'totalElements': jsonData['totalElements'],
          'totalPages': jsonData['totalPages'],
        };
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

  Future<void> postComment(String content, int boardId, String id) async {
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

    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");
    debugPrint(boardId.toString());
    if (response.statusCode == 201) {
      debugPrint("댓글이 성공적으로 전송되었습니다.");
    } else {
      debugPrint("댓글 전송에 실패하였습니다.");
      throw Exception("Failed to post comment");
    }
  }
}
