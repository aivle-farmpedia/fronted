import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PagingWidget extends StatefulWidget {
  final int totalPages;
  final Function onDelete;

  const PagingWidget({
    super.key,
    required this.totalPages,
    required this.onDelete,
  });

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<PagingWidget> {
  int currentPage = 1;
  final int itemsPerPage = 5;

  void _nextPage() {
    setState(() {
      if (currentPage < (widget.totalPages / itemsPerPage).ceil()) {
        currentPage++;
      }
    });
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  List<Widget> _buildNumberWidgets() {
    List<Widget> widgets = [];
    int startNumber = (currentPage - 1) * itemsPerPage + 1;
    for (int i = startNumber;
        i < startNumber + itemsPerPage && i <= widget.totalPages;
        i++) {
      widgets.add(
        InkWell(
          // 해당 페이지 버튼 눌렸을 때
          // 그 페이지로 API 요청하고 그 데이터들 받아오기

          onTap: () {
            widget.onDelete(i);
            // Handle page number click
            setState(() {
              currentPage = (i / itemsPerPage).ceil();
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 23),
            child: Text(
              '$i',
              style: const TextStyle(
                color: Colors.black,
                // backgroundColor: Colors.white,
              ),
            ),
          ),
          // SizedBox(width: 20)
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 왼쪽 버튼은 5보다 작을 경우 비활성화
          if (widget.totalPages > itemsPerPage && currentPage > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: currentPage > 1 ? _previousPage : null,
            ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildNumberWidgets(),
              ),
            ),
          ),
          // 오른쪽 버튼은 현재 보이는 페이지들이 totalPages가 있는 구간에 있다면 비활성화
          if (currentPage < (widget.totalPages / itemsPerPage).ceil())
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: _nextPage,
            ),
        ],
      ),
    );
  }
}
