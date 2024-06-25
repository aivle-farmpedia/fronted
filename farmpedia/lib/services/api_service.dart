import 'dart:convert';

import 'package:farmpedia/models/auto_complete_item_model.dart';
import 'package:farmpedia/models/search_keyword_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/board_model.dart';
import '../models/crop_info_model.dart';
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
    debugPrint(response.statusCode.toString());
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
      // debugPrint(body);
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
  Future<bool> putBoard(
      String title, String content, String id, int boardId) async {
    final url = Uri.parse("${baseurl}api/board/$boardId");
    debugPrint("$title $content $id $boardId");
    final Map<String, dynamic> params = {
      'title': title,
      'content': content,
    };
    debugPrint(json.encode(params));
    final response = await http.put(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
      body: json.encode(params),
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // 게시글 삭제
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

  Future<CropInfo> getCropsInfo(String id, int cropsId) async {
    final url = Uri.parse("${baseurl}api/crop/$cropsId");
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Authorization': id,
    });

    debugPrint("확인합시다. ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final json = jsonDecode(body);
      return CropInfo.fromJson(json);
    } else {
      throw Exception('Failed to load crop info');
    }
  }

  // 입력창
  Future<List<AutocompleteItem>> getContent(String id, String keywords) async {
    final url =
        Uri.parse("${baseurl}api/search/autocomplete?keyword=$keywords");
    debugPrint(url.toString());
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((item) => AutocompleteItem.fromJson(item)).toList();
    } else {
      debugPrint("에러");
      throw Exception('Failed to load autocomplete items');
    }
  }

  Future<List<SearchKeyword>> postKeyword(String id, String keyword) async {
    final url = Uri.parse("${baseurl}api/search?keyword=$keyword");
    final response = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Authorization': id,
    });
    debugPrint("???????? ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint("cropName 있는지 확인 ${body.toString()}");
      List<SearchKeyword> a =
          body.map((item) => SearchKeyword.fromJson(item)).toList();
      debugPrint(a.toString());
      return a;
    } else {
      debugPrint("에러");
      throw Exception('Failed to load autocomplete items');
    }
  }

  Future<List<String>> getrecent(String id) async {
    final url = Uri.parse("${baseurl}api/search/recent");
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Authorization': id,
    });
    debugPrint("정신차려 ${response.statusCode}");
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      final List<String> recentItems =
          body.map((item) => item.toString()).toList();
      debugPrint(
          "맞나요? ${recentItems.toString()} ${response.statusCode.toString()}");
      return recentItems;
    } else {
      throw Exception('Failed to load autocomplete items');
    }
  }

  // {{server}}/api/search?keyword=
  Future<bool> deleteKeyword(String id, String keywords) async {
    final url = Uri.parse("${baseurl}api/search?keyword=$keywords");
    final response = await http.delete(url, headers: {
      'Content-type': 'application/json',
      'Authorization': id,
    });
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
