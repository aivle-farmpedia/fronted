import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_searchbar_widget.dart';

class HomeScreen extends StatefulWidget {
  final String id;
  const HomeScreen({super.key, required this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  late List<String> userId;

  // Search 기능을 로컬에서 확인하기
  List<String> allItems = ["사과", "바나나", "체리", "밀", "포도", "보리", "사실"];
  List<String> filteredItems = [];
  // 사용자의 입력값을 확인함
  TextEditingController searchController = TextEditingController();
  bool onTextField = false;

  // 사용자의 개인 Id를 로컬 저장소에 저장한것
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getStringList('userId') ?? [];
    if (userId.isEmpty) {
      userId = [widget.id];
      await prefs.setStringList('userId', userId);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();

    // Search 기능
    filteredItems = allItems;
    // 사용자가 입력하면
    searchController.addListener(() {
      setState(() => onTextField = true);
      // 입력값을 filterSearchResults로 보냄
      filterSearchResults(searchController.text);
    });
  }

  // 사용자가 입력한 단어와 같은 단어가 있는지 확인
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      for (var item in allItems) {
        // 단어를 영어를 예로 들었기 떄문에 이렇게 사용했던거임
        // 리스트 단어를 한글로 수정함 -> 나중에 수정 필요
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        // 해당 단어를 포함한 단어 리스트를 갱신
        filteredItems = dummyListData;
      });
    } else {
      setState(() {
        // 단어 입력이 없으면 공백으로 갱신
        filteredItems = [];
      });
    }
  }

  @override
  void dispose() {
    // 삭제 기능
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xff95C461);
    // const Color barColor = Color(0xffF1F1F1);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            '귀농백과',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // 길어서 따로 위젯으로 뺌
              Expanded(
                child: CustomSearch(
                  mainColor: mainColor,
                  searchController: searchController,
                  filteredItems: filteredItems,
                  onTextField: onTextField,
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
