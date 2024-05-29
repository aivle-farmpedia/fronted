import 'package:farmpedia/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "귀농 지원",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SupportCard(
                      title: '롯데가 언제나 승리한다',
                      subtitle: '롯데한국시리즈',
                      color: Color.fromARGB(255, 188, 237, 131),
                      icon: Icons.account_circle,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SupportCard(
                      title: '롯데가 언제나 승리한다',
                      subtitle: '최강 롯데',
                      color: Colors.lightGreen,
                      icon: Icons.account_circle,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "혜택",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        SupportCard(
                          title: '엔씨 다이노스',
                          subtitle: '이기자',
                          color: Color.fromARGB(255, 188, 237, 131),
                          icon: Icons.account_circle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SupportCard(
                      title: '롯데 한국 시리즈',
                      subtitle: '최강 롯데',
                      color: Colors.lightGreen,
                      icon: Icons.account_circle,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  final double widthFactor;

  const SupportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.widthFactor = 1.35,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Card(
        color: color,
        child: ListTile(
          leading: Icon(
            icon,
            size: 40,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
          ),
        ),
      ),
    );
  }
}
