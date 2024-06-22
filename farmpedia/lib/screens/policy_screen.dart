import 'package:farmpedia/screens/example_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  final String id;
  final int privateId;
  const PolicyScreen({
    super.key,
    required this.id,
    required this.privateId,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> supportCards = [
      {
        'title': '롯데가 언제나 승리한다',
        'subtitle': '롯데한국시리즈',
        'color': const Color.fromARGB(255, 188, 237, 131),
        'icon': Icons.spa,
      },
      {
        'title': '롯데가 언제나 승리한다',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.spa,
      },
      {
        'title': '엔씨 다이노스',
        'subtitle': '이기자',
        'color': const Color.fromARGB(255, 188, 237, 131),
        'icon': Icons.spa,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.spa,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.spa,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.spa,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.spa,
      },
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: BackpageWidget(
            beforeContext: context,
          ),
          actions: [
            MenuWidget(
              id: id,
              privateId: privateId,
            )
          ],
          backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          title: const Text(
            "지원 정책",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "총 ${supportCards.length}건의 데이터",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: supportCards.length,
                itemBuilder: (context, index) {
                  final card = supportCards[index];
                  return Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: const Offset(10, 10),
                              color: const Color.fromARGB(255, 200, 198, 198)
                                  .withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: SupportCard(
                          title: card['title'],
                          subtitle: card['subtitle'],
                          color: card['color'],
                          icon: card['icon'],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final double height;
  final double titleFontSize;
  final double subtitleFontSize;
  final double iconSize;

  const SupportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.height = 100.0,
    this.titleFontSize = 23.0,
    this.subtitleFontSize = 16.0,
    this.iconSize = 47.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExampleScreen(title: title),
          ),
        );
      },
      child: SizedBox(
        height: height,
        child: Card(
          color: color,
          child: ListTile(
            leading: Icon(
              icon,
              size: iconSize,
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: titleFontSize, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                  fontSize: subtitleFontSize, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(const PolicyScreen(id:id));
// }
