import 'package:farmpedia/screens/menu_screen.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_searchbar_widget.dart';

class SearchScreen extends StatefulWidget {
  final int id;
  final String privateId;
  const SearchScreen({super.key, required this.id, required this.privateId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchContent = '';
  bool onTextField = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          onTextField = true;
          searchContent = searchController.text;
        });
      });
    });
  }

  @override
  void dispose() {
    // 삭제 기능
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => MenuScreen(
                      id: widget.id,
                      privateId: widget.privateId,
                    ),
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
          // backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          backgroundColor: const Color(0xff95C461),
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
                  onTextField: onTextField,
                  id: widget.id,
                  crops: searchContent,
                  privateId: widget.privateId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
