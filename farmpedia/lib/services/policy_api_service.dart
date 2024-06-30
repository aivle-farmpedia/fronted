// services/policy_api_service.dart 파일

import 'dart:convert';
import 'package:farmpedia/models/support_policy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/policy_model.dart';
import '../urls/urls.dart';

class PolicyApiService {
  final baseurl = Urls().uuidBaseUrl();

  // 모든 정책 목록을 가져오는 메서드
  Future<Map<String, dynamic>> getPolicyList(
      String id, int page, String category) async {
    final url =
        Uri.parse("${baseurl}api/support-policy?category=$category&page=$page");
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
        List<dynamic> policyJson = jsonData['data'];
        List<PolicyBoard> policyboards =
            policyJson.map((json) => PolicyBoard.fromJson(json)).toList();
        // boards.sort((a, b) => b.id.compareTo(a.id));
        return {
          'policyboards': policyboards,
          'page': jsonData['page'],
          'size': jsonData['size'],
          'totalElements': jsonData['totalElements'],
          'totalPages': jsonData['totalPages'],
        };
      } else {
        throw Exception('Invalid JSON structure');
      }
    } else {
      debugPrint('Failed to load boards: Status code ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint("여기 에러");
      throw Exception('Failed to load boards');
    }
  }

  // 특정 정책의 상세 정보를 가져오는 메서드
  Future<SupportPolicy> getPolicyDetails(int policyId, String id) async {
    final url = Uri.parse("${baseurl}api/support-policy/$policyId");

    print('Request URL: $url');
    print('Headers: Authorization=$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': id,
          'Accept-Encoding': 'identity',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = jsonDecode(body);
        print('Decoded JSON: $jsonData');

        // jsonData는 이미 데이터 객체 자체로 보이므로 'data' 키를 확인할 필요가 없습니다.
        return SupportPolicy.fromJson(jsonData);
      } else {
        print(
            'Failed to load policy details: Status code ${response.statusCode}');
        throw Exception('Failed to load policy details');
      }
    } catch (e) {
      print('Error in getPolicyDetails: $e');
      rethrow;
    }
  }
}
