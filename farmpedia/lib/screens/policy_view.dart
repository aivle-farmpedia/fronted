import 'package:farmpedia/models/support_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PolicyView extends StatelessWidget {
  final SupportPolicy supportPolicy;

  const PolicyView({super.key, required this.supportPolicy});

  @override
  Widget build(BuildContext context) {
    // Split the content at 'o' and then join it back with '\n○' to ensure new lines
    String contentWithNewLines = supportPolicy.content.split('○').join('\n○');
    List<String> contentParagraphs = contentWithNewLines.split('\n');

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
            Text('가격: ${supportPolicy.price}'),
            const SizedBox(height: 10),
            Text('정보 URL: ${supportPolicy.infoUrl}'),
          ],
        ),
      ),
    );
  }
}
