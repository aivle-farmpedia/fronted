import 'dart:convert';

// import 'package:farmpedia/models/uuid_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../urls/urls.dart';

class ApiService {
  final baseurl = Urls().uuidBaseUrl();

  Future<String> postUuid(List<String> userId, SharedPreferences prefs) async {
    String uuidInstance = '';
    final url = Uri.parse(baseurl);
    final Map<String, dynamic> params = {'uuid': userId[0]};
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: json.encode(params),
    );
    if (response.statusCode == 200) {
      debugPrint("성공");
      final dynamic uuids = await jsonDecode(response.body);
      uuidInstance = uuids;
      await prefs.setStringList('userId', [uuidInstance]);
      return uuidInstance;
    }

    debugPrint("이건 언제됨? ${response.body}");
    throw Error();
  }
}
