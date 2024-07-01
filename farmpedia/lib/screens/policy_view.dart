import 'package:farmpedia/models/support_policy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; 

class PolicyView extends StatelessWidget {
  final SupportPolicy supportPolicy;

  const PolicyView({super.key, required this.supportPolicy});

  String replaceSpecialCharacters(String content) {
    return content
        .replaceAll('○', '\n○')
        .replaceAll('ㅇ', '\nㅇ')
        .replaceAll('?', '');
  }

  String formatPrice(String price) {
    try {
      final intPrice = int.parse(price);
      final NumberFormat numberFormat = NumberFormat('#,###');
      return numberFormat.format(intPrice);
    } catch (e) {
      return price;
    }
  }

  @override
  Widget build(BuildContext context) {
    String contentWithNewLines = replaceSpecialCharacters(supportPolicy.content);
    List<String> contentParagraphs = contentWithNewLines.split('\n');
    String formattedPrice = formatPrice(supportPolicy.price.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(supportPolicy.title),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supportPolicy.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildContentCard(contentParagraphs),
            const SizedBox(height: 20),
            _buildCardSection(
              title: '신청 기간',
              content: Column(
                children: [
                  _buildInfoRow('시작:', supportPolicy.applyStart, Icons.calendar_today),
                  _buildInfoRow('종료:', supportPolicy.applyEnd, Icons.calendar_today_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildCardSection(
              title: '지원 정보',
              content: Column(
                children: [
                  _buildInfoRow('책임 기관:', supportPolicy.chargeAgency, Icons.account_balance),
                  _buildInfoRow('교육 대상:', supportPolicy.eduTarget, Icons.school),
                  _buildInfoRow('지원 금액:', '$formattedPrice원', Icons.monetization_on),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(supportPolicy.infoUrl);
                  if (await canLaunch(url.toString())) {
                    await launch(url.toString());
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                icon: const Icon(Icons.link),
                label: const Text(
                  '정보 URL 보기',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildContentCard(List<String> paragraphs) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: paragraphs.map((paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  paragraph,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              )).toList(),
        ),
      ),
    );
  }

  Widget _buildCardSection({required String title, required Widget content}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
