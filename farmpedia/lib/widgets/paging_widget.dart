import 'package:flutter/material.dart';

class PagingWidget extends StatefulWidget {
  final int totalPages;
  const PagingWidget({
    super.key,
    required this.totalPages,
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
        ElevatedButton(
          onPressed: () {
            // Handle page number click
            setState(() {
              currentPage = (i / itemsPerPage).ceil();
            });
          },
          child: Text(
            '$i',
            style: const TextStyle(color: Colors.black),
          ),
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
          if (widget.totalPages > itemsPerPage)
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
