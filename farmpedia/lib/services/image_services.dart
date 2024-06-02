import 'dart:convert';

import 'package:flutter/services.dart';

class ImageService {
  static Future<List<String>> getImageList() async {
    // pubspec.yaml에 명시된 assets의 경로
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // images/ 디렉토리 내의 이미지들을 찾아서 리스트에 추가
    final imagePaths = manifestMap.keys
        .where((String key) => key.startsWith('images/'))
        .toList();

    return imagePaths;
  }
}
