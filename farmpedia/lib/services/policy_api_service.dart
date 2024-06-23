// services/policy_api_service.dart 파일

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/policy_model.dart';
import '../urls/urls.dart';

class PolicyApiService {
  final baseurl = Urls().uuidBaseUrl();

  // 모든 정책 목록을 가져오는 메서드
  Future<Map<String, dynamic>> getPolicyList(String id, int page) async {
    final url = Uri.parse("${baseurl}api/support-policy?page=$page");
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
        List<PolicyBoard> boards =
            boardsJson.map((json) => PolicyBoard.fromJson(json)).toList();
        boards.sort((a, b) => b.id.compareTo(a.id));
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
}
