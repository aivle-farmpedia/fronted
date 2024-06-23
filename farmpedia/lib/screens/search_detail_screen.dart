import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Updated import

import '../models/crop_info_model.dart';
import '../services/api_service.dart';

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
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xffF0F0F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.crops} 입니다~~",
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "1. 판매 가격 추이(3개년)",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cropInfo.priceEntries.map((entry) {
                                  return Text(
                                      'Date: ${entry.priceDate}, Price: ${entry.price}');
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "2. 면적당 수확량(계산기)",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                  'Area Per Yield: ${cropInfo.crop.areaPerYield}'),
                              const SizedBox(height: 20),
                              const SizedBox(height: 20),
                              const Text(
                                "3. 재배영상",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () async {
                                  final url =
                                      Uri.parse(cropInfo.crop.cultivationUrl);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Text(
                                  cropInfo.crop.cultivationUrl,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(
                                "4. 품종",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: cropInfo.varieties.map((variety) {
                                  return ListTile(
                                    title: Text(variety.name),
                                    subtitle: Text(
                                        'Purpose: ${variety.purpose}\nSkill: ${variety.skill}'),
                                    leading: Image.network(variety.imageUrl),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "5. 생육과정",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    cropInfo.cropProcesses.expand((process) {
                                  return [
                                    Text(
                                        '${process.processOrder}. ${process.task}: ${process.description}'),
                                    const SizedBox(height: 20),
                                  ];
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
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
