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

  // 댓글 추가 함수
  Future<String> postComment(String content, int boardId, String id) async {
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

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final commentId =
          responseData['id']; // Assuming the response body contains the ID
      debugPrint("댓글이 성공적으로 전송되었습니다. ID: $commentId");
      return commentId.toString(); // Return the comment ID as string
    } else {
      debugPrint("댓글 전송에 실패하였습니다.");
      throw Exception("Failed to post comment");
    }
  }

  // 답글 추가 함수
  Future<Map<String, dynamic>> postReply(
      String text, int boardId, String id, String commentId) async {
    debugPrint("ParentID: $commentId");

    final url = Uri.parse("${baseurl}api/comment/reply/$boardId");
    final body = json.encode({"content": text, "parentId": commentId});
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Authorization': id,
      },
      body: body,
    );

    debugPrint("Request URL: ${url.toString()}");
    if (response.statusCode == 201) {
      debugPrint("답글이 성공적으로 전송되었습니다.");
      return jsonDecode(response.body);
    } else {
      debugPrint("답글 전송에 실패하였습니다.");
      debugPrint("Response: ${response.body}"); // 추가: 응답 본문 디버깅
      throw Exception("Failed to post reply");
    }
  }

  // 댓글 수정 함수
  Future<void> editComment(
      String newComment, int boardId, String postId, String commentId) async {
    final url = Uri.parse('$baseurl/api/comment/$boardId');
    final body = jsonEncode({
      'newComment': newComment,
      'postId': postId,
      'parentId': commentId, // 댓글 ID 추가
    });

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': postId,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("댓글이 성공적으로 수정되었습니다.");
    } else {
      debugPrint("댓글 수정에 실패하였습니다.");
      throw Exception("Failed to edit comment");
    }
  }

  // 댓글 삭제 함수
  Future<void> deleteComment(
      int boardId, String postId, String commentId) async {
    final url = Uri.parse('$baseurl/api/comment/$boardId');
    final body = jsonEncode({
      'postId': postId,
      'parentId': commentId, // 댓글 ID 추가
    });

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': postId,
      },
      body: body,
    );

    if (response.statusCode == 200) {
      debugPrint("댓글이 성공적으로 삭제되었습니다.");
    } else {
      debugPrint("댓글 삭제에 실패하였습니다.");
      throw Exception("Failed to delete comment");
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
