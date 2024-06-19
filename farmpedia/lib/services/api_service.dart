import 'dart:convert';

// import 'package:farmpedia/models/uuid_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      debugPrint(response.body.toString());
    } else {
      throw Error;
    }
  }
}
