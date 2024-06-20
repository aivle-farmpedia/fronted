import 'dart:convert';

// import 'package:farmpedia/models/uuid_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/board_model.dart';
import '../urls/urls.dart';

class ApiService {
  final baseurl = Urls().uuidBaseUrl();

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
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Content-Length Header: ${response.headers['content-length']}');
    debugPrint('Body Length: ${response.bodyBytes.length}');

    debugPrint(response.statusCode.toString());
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
}
