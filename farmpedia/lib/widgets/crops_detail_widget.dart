import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/crop_info_model.dart';
import '../screens/search_detail_screen.dart';
import 'price_chart_widget.dart';

class cropsDetail extends StatelessWidget {
  const cropsDetail({
    super.key,
    required ScrollController scrollController,
    required this.widget,
    required this.groupedEntries,
    required this.cropInfo,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final SearchDetailScreen widget;
  final Map<int, List<PriceEntry>> groupedEntries;
  final CropInfo cropInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xffF0F0F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.crops,
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
                  children: groupedEntries.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key}년",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 300,
                          width: double.infinity, // Ensure it fits the parent
                          child: CustomPaint(
                            painter: BarChartPainter(priceEntries: entry.value),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }).toList(),
                ),
                Container(
                  height: 2.0,
                  width: 500,
                  color: const Color(0xFF95c452),
                ),
                const SizedBox(height: 20),
                const Text(
                  "2. 수확량",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Text('면적당 생산량: ${cropInfo.crop.areaPerYield ?? '정보없음'}'),
                Text('시간당 생산량: ${cropInfo.crop.timePerYield ?? '정보없음'}'),
                const SizedBox(height: 20),
                Container(
                  height: 2.0,
                  width: 500,
                  color: const Color(0xFF95c452),
                ),
                const SizedBox(height: 20),
                const Text(
                  "3. 재배영상",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: cropInfo.crop.cultivationUrl != null
                      ? () async {
                          final url = Uri.parse(cropInfo.crop.cultivationUrl!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      : null,
                  child: Text(
                    cropInfo.crop.cultivationUrl ?? 'No video available',
                    style: TextStyle(
                      color: cropInfo.crop.cultivationUrl != null
                          ? Colors.blue
                          : Colors.grey,
                      decoration: cropInfo.crop.cultivationUrl != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 2.0,
                  width: 500,
                  color: const Color(0xFF95c452),
                ),
                const SizedBox(height: 20),
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
                      leading: variety.imageUrl.isNotEmpty
                          ? Image.network(variety.imageUrl)
                          : const Icon(Icons.image_not_supported),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 2.0,
                  width: 500,
                  color: const Color(0xFF95c452),
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
                  children: cropInfo.cropProcesses.expand((process) {
                    return [
                      Text(
                          '${process.processOrder}. ${process.task}: ${process.description}'),
                      const SizedBox(height: 20),
                      Container(
                        height: 2.0,
                        width: 500,
                        color: const Color(0xFF95c452),
                      ),
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
  }
}
