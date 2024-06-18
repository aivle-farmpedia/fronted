import 'dart:convert';

// import 'package:farmpedia/models/uuid_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../urls/urls.dart';

class ApiService {
  final baseurl = Urls().uuidBaseUrl();

  Future<String> postUuid(String userId) async {
    // String uuidInstance = '';
    debugPrint("???????? $userId");
    final url = Uri.parse(baseurl);
    final Map<String, dynamic> params = {'uuid': userId};
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(params),
    );
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 201) {
      debugPrint("성공");
      return "성공";
    } else {
      debugPrint("화면이 나오면 안됨");
      throw Error();
    }
  }
}
