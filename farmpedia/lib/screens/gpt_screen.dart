import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/meun_widget.dart';
import 'package:flutter/material.dart';

class GPTScreen extends StatelessWidget {
  const GPTScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: BackpageWidget(
            beforeContext: context,
          ),
          actions: const [MeunWidget()],
          backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          title: const Text(
            "귀농GPT",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2CD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '사과에 대해 설명해줘',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '사과 품종 정보\n'
                      '주요 사과 품종: 조생종 아오리, 중생종 홍로, 만생종 후지(부사) 등\n\n'
                      '* 아오리 사과: 일본에서 도입된 품종으로 초기에는 재배가 어려웠으나 점차 인기 상승\n'
                      '* 홍로 사과: 추석 명절에 많이 소비되는 중생종 품종\n'
                      '* 양광 사과: 일본에서 도입된 품종으로 아름다운 색상과 감미 당도가 높음\n'
                      '* 후지(부사) 사과: 국내에서 가장 많이 재배되는 만생종 품종\n\n'
                      '- 사과 재배 기술\n'
                      '* 사과나무 수형 관리, 수확 및 과실 품질 향상을 위한 재배 기술\n'
                      '* 토양 조건, 재식 방법, 대목 선택에 따른 차이가 큼\n'
                      '* 키 낮은 사과원 조성 시 필수 조건\n'
                      '* 기상 재해 방지를 위한 재배 방법 중요',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  hintText: '입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
