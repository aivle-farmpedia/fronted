import 'package:farmpedia/widgets/price_chart_widget.dart';
import 'package:flutter/material.dart';
import '../models/crop_info_model.dart';
import '../services/api_service.dart';
import '../widgets/backpage_widget.dart';
import '../widgets/crops_detail_widget.dart';
import '../widgets/menu_widget.dart';

class SearchDetailScreen extends StatefulWidget {
  final String crops;
  final String id;
  final int privateId;

  const SearchDetailScreen({
    super.key,
    required this.crops,
    required this.id,
    required this.privateId,
  });

  @override
  State<SearchDetailScreen> createState() => _SearchDetailScreenState();
}

class _SearchDetailScreenState extends State<SearchDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<CropInfo> cropInfoFuture;

  Future<CropInfo> cropsInfo() async {
    return await ApiService().getCropsInfo(widget.id, 2);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cropInfoFuture = cropsInfo();
  }

  Map<int, List<PriceEntry>> _groupEntriesByYear(List<PriceEntry> entries) {
    Map<int, List<PriceEntry>> groupedByYear = {};

    for (var entry in entries) {
      int year = DateTime.parse(entry.priceDate).year;
      if (!groupedByYear.containsKey(year)) {
        groupedByYear[year] = [];
      }
      groupedByYear[year]!.add(entry);
    }

    return groupedByYear;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff95C461),
          leading: BackpageWidget(beforeContext: context),
          centerTitle: true,
          title: Text(widget.crops),
          actions: [
            MenuWidget(
              id: widget.id,
              privateId: widget.privateId,
            ),
          ],
        ),
        body: Stack(
          children: [
            FutureBuilder<CropInfo>(
              future: cropInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final cropInfo = snapshot.data!;
                  final groupedEntries =
                      _groupEntriesByYear(cropInfo.priceEntries);
                  return cropsDetail(
                      scrollController: _scrollController,
                      widget: widget,
                      groupedEntries: groupedEntries,
                      cropInfo: cropInfo);
                } else {
                  return const Center(child: Text('No data found.'));
                }
              },
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: FloatingActionButton.small(
                shape: const CircleBorder(),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff95C461),
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
