import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  const CustomSearch({
    super.key,
    required this.mainColor,
    required this.searchController,
    required this.filteredItems,
    required this.onTextField,
  });

  final Color mainColor;
  final TextEditingController searchController;
  final List<String> filteredItems;
  final bool onTextField;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: searchController,
                    autocorrect: false, // 자동 수정 비활성화
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text, // 텍스트 입력 설정
                    decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      suffixIcon: Icon(
                        Icons.search_outlined,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 사용자가 단어를 입력했거나 단어 리스트가 공백 아닐 때
        // 입력된 단어의 리스트들을 보여줌

        Flexible(
          child: filteredItems.isNotEmpty && onTextField
              ? ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredItems[index]),
                    );
                  },
                )
              : const SizedBox(
                  height: 20,
                ),
        ),
      ],
    );
  }
}
