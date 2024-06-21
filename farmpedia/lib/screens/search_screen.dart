import 'package:farmpedia/screens/menu_screen.dart';
import 'package:farmpedia/screens/search_detail_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_searchbar_widget.dart';

class SearchScreen extends StatefulWidget {
  final String id;
  const SearchScreen({super.key, required this.id});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> allItems = ["사과", "바나나", "체리", "밀", "포도", "보리", "사실"];
  List<String> filteredItems = [];

  // 사용자의 입력값을 확인함
  TextEditingController searchController = TextEditingController();
  String searchContent = '';
  bool onTextField = false;

  @override
  void initState() {
    super.initState();
    // Search 기능
    filteredItems = allItems;
    // 사용자가 입력하면
    searchController.addListener(() {
      setState(() {
        onTextField = true;
        searchContent = searchController.text;
      });
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
    const Color barColor = Color(0xffE7E7E7);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: BackpageWidget(
            beforeContext: context,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuScreen(id: widget.id),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Icon(
                  Icons.menu,
                  size: 30.0,
                ),
              ),
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          title: const Text(
            "검색창",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // 길어서 따로 위젯으로 뺌
              Expanded(
                child: CustomSearch(
                  mainColor: barColor,
                  searchController: searchController,
                  filteredItems: filteredItems,
                  onTextField: onTextField,
                  id: widget.id,
                  crops: searchContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
