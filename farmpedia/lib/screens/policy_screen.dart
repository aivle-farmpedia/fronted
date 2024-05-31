import 'package:farmpedia/screens/example_screen.dart';
import 'package:farmpedia/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> supportCards = [
      {
        'title': '롯데가 언제나 승리한다',
        'subtitle': '롯데한국시리즈',
        'color': const Color.fromARGB(255, 188, 237, 131),
        'icon': Icons.account_circle,
      },
      {
        'title': '롯데가 언제나 승리한다',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.account_circle,
      },
      {
        'title': '엔씨 다이노스',
        'subtitle': '이기자',
        'color': const Color.fromARGB(255, 188, 237, 131),
        'icon': Icons.account_circle,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.account_circle,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.account_circle,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.account_circle,
      },
      {
        'title': '롯데 한국 시리즈',
        'subtitle': '최강 롯데',
        'color': Colors.lightGreen,
        'icon': Icons.account_circle,
      },
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuScreen(),
                  ),
                );
              },
              child: const Icon(Icons.menu),
            ),
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
                          borderRadius: BorderRadius.circular(15),
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

  const SupportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
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
      child: Card(
        color: color,
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

void main() {
  runApp(const PolicyScreen());
}
