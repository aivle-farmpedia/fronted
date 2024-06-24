import 'package:flutter/material.dart';

class RecentKeywordsWidget extends StatelessWidget {
  final List<String> recentKeywords;
  final Function(String) onDeleteKeyword;
  final Function(String) onKeywordTap;

  const RecentKeywordsWidget({
    super.key,
    required this.recentKeywords,
    required this.onDeleteKeyword,
    required this.onKeywordTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '최근 검색어',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: recentKeywords
                .map(
                  (keyword) => GestureDetector(
                    onTap: () => onKeywordTap(keyword),
                    child: Chip(
                      label: Text(keyword),
                      onDeleted: () {
                        onDeleteKeyword(keyword);
                      },
                      deleteIcon: const Icon(Icons.delete),
                      // deleteIconColor: Colors.red,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
