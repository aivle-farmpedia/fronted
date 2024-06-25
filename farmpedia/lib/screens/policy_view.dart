import 'package:farmpedia/models/support_policy.dart';
import 'package:farmpedia/widgets/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // intl 패키지 import/ WebViewScreen 위젯 import

class PolicyView extends StatelessWidget {
  final SupportPolicy supportPolicy;

  const PolicyView({super.key, required this.supportPolicy});

  String replaceSpecialCharacters(String content) {
    return content
        .replaceAll('○', '\n○')
        .replaceAll('ㅇ', '\nㅇ')
        .replaceAll('?', ''); // '는 공백 대신 제거
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  String formatPrice(String price) {
    try {
      final intPrice = int.parse(price);
      final NumberFormat numberFormat = NumberFormat('#,###');
      return numberFormat.format(intPrice);
    } catch (e) {
      // 오류가 발생할 경우 원래 문자열을 반환
      return price;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split the content at 'o' and then join it back with '\n○' to ensure new lines
    String contentWithNewLines =
        replaceSpecialCharacters(supportPolicy.content);
    List<String> contentParagraphs = contentWithNewLines.split('\n');

    // 천단위로 쉼표 추가
    String formattedPrice = formatPrice(supportPolicy.price.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(supportPolicy.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제목: ${supportPolicy.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '내용:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...contentParagraphs.map((paragraph) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(paragraph),
                )),
            const SizedBox(height: 10),
            Text('신청 시작: ${supportPolicy.applyStart}'),
            const SizedBox(height: 10),
            Text('신청 종료: ${supportPolicy.applyEnd}'),
            const SizedBox(height: 10),
            Text('책임 기관: ${supportPolicy.chargeAgency}'),
            const SizedBox(height: 10),
            Text('교육 대상: ${supportPolicy.eduTarget}'),
            const SizedBox(height: 10),
            Text('가격: $formattedPrice원'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _openWebView(context, supportPolicy.infoUrl),
              child: Text(
                '정보 URL: ${supportPolicy.infoUrl}',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
