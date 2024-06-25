import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../urls/urls.dart';

class CommentApiService {
  final baseurl = Urls().uuidBaseUrl();

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

//댓글 수정 함수
  Future<void> editComment(String content, String id, String commentId) async {
    final url = Uri.parse('${baseurl}api/comment/$commentId');
    final body = jsonEncode({
      'content': content,
    });

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': id,
      },
      body: body,
    );

    if (response.statusCode == 204) {
      debugPrint("댓글이 성공적으로 수정되었습니다.");
    } else {
      debugPrint("댓글 수정에 실패하였습니다.");
      throw Exception("Failed to edit comment");
    }
  }

  // 댓글 삭제 함수
  Future<void> deleteComment(String id, String commentId) async {
    final url = Uri.parse('${baseurl}api/comment/$commentId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': id,
      },
    );

    if (response.statusCode == 204) {
      debugPrint("댓글이 성공적으로 삭제되었습니다.");
    } else {
      debugPrint("댓글 삭제에 실패하였습니다.");
      throw Exception("Failed to delete comment");
    }
  }

  //댓글 불러오는 함수
  Future<Map<String, dynamic>> fetchComments(int boardId, String id) async {
    final url = Uri.parse('${baseurl}api/comment/board/$boardId');
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Authorization': id,
      },
    );

    if (response.statusCode == 200) {
      // 응답 본문을 UTF-8로 디코딩하여 JSON으로 변환합니다.
      final decodedBody = utf8.decode(response.bodyBytes);
      debugPrint(decodedBody);
      return json.decode(decodedBody);
    } else {
      // 에러 발생 시 상태 코드와 응답 본문을 포함한 예외를 발생시킵니다.
      throw Exception(
          'Failed to load comments. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
