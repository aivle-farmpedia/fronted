import 'dart:async';
import 'package:flutter/material.dart';
import 'package:farmpedia/models/search_keyword_model.dart';
import 'package:farmpedia/services/api_service.dart';
import '../screens/search_detail_screen.dart';
import 'recently_keywords_widget.dart';

class CustomSearch extends StatefulWidget {
  final int id;
  final String crops;
  final Color mainColor;
  final TextEditingController searchController;
  final bool onTextField;
  final String privateId;
  const CustomSearch({
    super.key,
    required this.mainColor,
    required this.searchController,
    required this.onTextField,
    required this.id,
    required this.crops,
    required this.privateId,
  });
  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  List<SearchKeyword> _searchKeywords = [];
  List<String> _recentKeywords = [];
  bool _isLoading = false;
  bool _isDelete = false;
  Timer? _debounce;

  Future<void> fetchSearch(String id, String keywords) async {
    setState(() {
      _isLoading = true;
    });
    final keys = await ApiService().postKeyword(id, keywords);
    setState(() {
      _searchKeywords = keys;
      _isLoading = false;
    });
  }

  Future<void> fetchRecentKeywords(String id, {String? newKeyword}) async {
    try {
      final recentKeywords = await ApiService().getrecent(id);
      setState(() {
        _recentKeywords = recentKeywords;
        if (newKeyword != null && !_recentKeywords.contains(newKeyword)) {
          _recentKeywords.insert(0, newKeyword); // Add new keyword to the top
        }
      });
    } catch (e) {
      debugPrint('Failed to fetch recent keywords: $e');
    }
  }

  Future<void> _getAndNavigateToKeyword(String keyword) async {
    try {
      final autocompleteItems =
          await ApiService().getKeyword(widget.privateId, keyword);
      if (autocompleteItems.isNotEmpty) {
        final cropId = autocompleteItems.first.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchDetailScreen(
              id: widget.id,
              crops: keyword,
              privateId: widget.privateId,
              cropId: cropId,
            ),
          ),
        ).then((_) {
          fetchRecentKeywords(widget.privateId);
        });
      } else {
        debugPrint('No matching items found for keyword: $keyword');
      }
    } catch (e) {
      debugPrint('Error fetching autocomplete items: $e');
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        fetchSearch(widget.privateId, value);
      } else {
        setState(() {
          _searchKeywords = [];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(() {
      _onSearchChanged(widget.searchController.text);
    });
    if (widget.searchController.text.isNotEmpty) {
      fetchSearch(widget.privateId, widget.searchController.text);
    } else {
      fetchRecentKeywords(widget.privateId);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.searchController.removeListener(() {
      _onSearchChanged(widget.searchController.text);
    });
    super.dispose();
  }

  void _deleteKeyword(String id, String keywords) async {
    _isDelete = await ApiService().deleteKeyword(id, keywords);
    if (_isDelete) {
      fetchRecentKeywords(widget.privateId);
    }
  }

  void _onKeywordTap(String keyword) {
    widget.searchController.text = keyword;
    fetchSearch(widget.privateId, keyword);
  }

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
                    onSubmitted: (value) async {
                      if (value.isNotEmpty && _searchKeywords.isNotEmpty) {
                        final matchingItem = _searchKeywords
                            .firstWhere((item) => item.name == value);
                        await _getAndNavigateToKeyword(matchingItem.cropName);
                        widget.searchController.clear();
                        await fetchRecentKeywords(widget.privateId,
                            newKeyword:
                                value); // Add new keyword to recent list
                        setState(() {
                          _searchKeywords.clear();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: widget.onTextField
              ? _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchKeywords.isEmpty
                      ? RecentKeywordsWidget(
                          recentKeywords: _recentKeywords,
                          onDeleteKeyword: (keyword) {
                            _deleteKeyword(widget.privateId, keyword);
                          },
                          onKeywordTap: _onKeywordTap,
                        )
                      : ListView.builder(
                          itemCount: _searchKeywords.length,
                          itemBuilder: (context, index) {
                            final item = _searchKeywords[index];
                            return ListTile(
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(item.name),
                              subtitle: Text("품종 : ${item.cropName}"),
                              onTap: () async {
                                await _getAndNavigateToKeyword(item.cropName);
                                widget.searchController.clear();
                              },
                            );
                          },
                        )
              : RecentKeywordsWidget(
                  recentKeywords: _recentKeywords,
                  onDeleteKeyword: (keyword) {
                    _deleteKeyword(widget.privateId, keyword);
                  },
                  onKeywordTap: _onKeywordTap,
                ),
        ),
      ],
    );
  }
}
