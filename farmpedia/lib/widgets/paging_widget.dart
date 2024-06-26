import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PagingWidget extends StatefulWidget {
  final int totalPages;
  final Function(int page) onPageChange;

  const PagingWidget({
    super.key,
    required this.totalPages,
    required this.onPageChange,
  });

  @override
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<PagingWidget> {
  int currentPage = 1;
  final int itemsPerPage = 5;

  void _nextPage() {
    setState(() {
      if (currentPage < widget.totalPages) {
        currentPage =
            ((currentPage - 1) ~/ itemsPerPage + 1) * itemsPerPage + 1;
        widget.onPageChange(currentPage);
      }
    });
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage = ((currentPage - 1) ~/ itemsPerPage) * itemsPerPage -
            (itemsPerPage - 1);
        if (currentPage < 1) currentPage = 1;
        widget.onPageChange(currentPage);
      });
    }
  }

  List<Widget> _buildNumberWidgets() {
    List<Widget> widgets = [];
    int startNumber = ((currentPage - 1) ~/ itemsPerPage) * itemsPerPage + 1;
    for (int i = startNumber;
        i < startNumber + itemsPerPage && i <= widget.totalPages;
        i++) {
      widgets.add(
        InkWell(
          onTap: () {
            widget.onPageChange(i);
            setState(() {
              currentPage = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 23),
            child: Text(
              '$i',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    int startNumber = ((currentPage - 1) ~/ itemsPerPage) * itemsPerPage + 1;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (startNumber > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _previousPage,
            ),
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildNumberWidgets(),
              ),
            ),
          ),
          if (startNumber + itemsPerPage <= widget.totalPages)
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: _nextPage,
            ),
        ],
      ),
    );
  }
}
