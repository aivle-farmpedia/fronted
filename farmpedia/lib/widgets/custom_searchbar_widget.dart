import 'package:flutter/material.dart';

class CustomSearch extends StatefulWidget {
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
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.mainColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: widget.searchController,
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
          child: widget.filteredItems.isNotEmpty && widget.onTextField
              ? ListView.builder(
                  itemCount: widget.filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: GestureDetector(
                        onTap: () {
                          // 단어 클릭시 그 단어로 searchbar에 바로 반영 된다
                          widget.searchController.text =
                              widget.filteredItems[index];
                        },
                        child: Text(widget.filteredItems[index]),
                      ),
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
