import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/crop_info_model.dart';
import 'price_chart_widget.dart';

class CropsDetail extends StatelessWidget {
  const CropsDetail({
    super.key,
    required ScrollController scrollController,
    required this.widget,
    required this.groupedEntries,
    required this.cropInfo,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final dynamic widget; // Update to dynamic or specific type if necessary
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
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GmarketSans',
                    fontSize: 25,
                    color: Color(0xff4CAF50),
                  ),
                ),
                const SizedBox(height: 20),
                buildSectionTitle("판매 가격 추이 (3년간)"),
                const SizedBox(height: 20),
                Column(
                  children: groupedEntries.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key}년",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GmarketSans',
                              fontSize: 16,
                              color: Color(0xff388E3C)),
                        ),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: BarChartPainter(priceEntries: entry.value),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    );
                  }).toList(),
                ),
                buildDivider(),
                buildSectionTitle("수확량 정보"),
                const SizedBox(height: 20),
                buildInfoRow("면적당 생산량", cropInfo.crop.areaPerYield != null ? '${cropInfo.crop.areaPerYield}원' : '정보 없음'),
                buildInfoRow("시간당 생산량", cropInfo.crop.timePerYield != null ? '${cropInfo.crop.timePerYield}원' : '정보 없음'),
                const SizedBox(height: 20),
                buildDivider(),
                buildSectionTitle("재배 영상"),
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
                    cropInfo.crop.cultivationUrl ?? '사용 가능한 영상이 없습니다',
                    style: TextStyle(
                      color: cropInfo.crop.cultivationUrl != null
                          ? Colors.green
                          : Colors.grey,
                      decoration: cropInfo.crop.cultivationUrl != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildDivider(),
                buildSectionTitle("품종 정보"),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cropInfo.varieties.map((variety) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(variety.name),
                        subtitle: Text(
                            '용도: ${variety.purpose}\n재배 기술: ${variety.skill}'),
                        leading: variety.imageUrl.isNotEmpty
                            ? Image.network(variety.imageUrl)
                            : const Icon(Icons.image_not_supported),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                buildDivider(),
                buildSectionTitle("생육 과정"),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cropInfo.cropProcesses.expand((process) {
                    return [
                      buildProcessStep(process),
                      const SizedBox(height: 20),
                      buildDivider(),
                      const SizedBox(height: 20),
                    ];
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'GmarketSans',
        fontSize: 18,
        color: Color(0xff388E3C),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'GmarketSans',
            fontSize: 16,
            color: Color(0xff616161),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'GmarketSans',
            fontSize: 16,
            color: Color(0xff212121),
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Container(
      height: 2.0,
      width: double.infinity,
      color: const Color(0xFF95c452),
    );
  }

  Widget buildProcessStep(CropProcess process) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${process.processOrder}. ${process.task}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'GmarketSans',
            fontSize: 16,
            color: Color(0xff4CAF50),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          process.description,
          style: const TextStyle(
            fontFamily: 'GmarketSans',
            fontSize: 14,
            color: Color(0xff757575),
          ),
        ),
      ],
    );
  }
}
