import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../models/crop_info_model.dart';

class BarChartPainter extends CustomPainter {
  final List<PriceEntry> priceEntries;

  BarChartPainter({required this.priceEntries});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff95C461)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    final circlePaint = Paint()
      ..color = const Color(0xff95C461)
      ..style = PaintingStyle.fill;

    // Adjusted X and Y axis positions
    const double xOffset = 40; // Adjusted for Y-axis labels
    const double yOffset = 40;

    // Draw X and Y axis
    canvas.drawLine(const Offset(xOffset, 0),
        Offset(xOffset, size.height - yOffset), axisPaint);
    canvas.drawLine(Offset(xOffset, size.height - yOffset),
        Offset(size.width, size.height - yOffset), axisPaint);

    final double maxPrice = priceEntries
        .map((entry) => entry.price)
        .reduce((a, b) => a > b ? a : b);
    final double minPrice = priceEntries
        .map((entry) => entry.price)
        .reduce((a, b) => a < b ? a : b);

    // Round max and min prices to nearest ten thousand
    final int maxPriceRounded = ((maxPrice / 10000).round()) * 10000;
    final int minPriceRounded = ((minPrice / 10000).round()) * 10000;

    final DateFormat monthFormat = DateFormat('MM');
    const TextStyle labelStyle = TextStyle(color: Colors.black, fontSize: 10);

    // Draw Y-axis max price label
    final TextPainter maxPriceTextPainter = TextPainter(
      text: TextSpan(
          text: '${(maxPriceRounded / 10000).toStringAsFixed(0)}만원',
          style: labelStyle),
      textAlign: TextAlign.right,
      textDirection: ui.TextDirection.ltr,
    );
    maxPriceTextPainter.layout();
    maxPriceTextPainter.paint(
        canvas, Offset(xOffset - maxPriceTextPainter.width - 5, 0));

    // Find the position for the min price label
    final double minPricePosition = size.height -
        yOffset -
        (minPrice / maxPriceRounded * (size.height - yOffset - 20));

    final TextPainter minPriceTextPainter = TextPainter(
      text: TextSpan(
          text: '${(minPriceRounded / 10000).toStringAsFixed(0)}만원',
          style: labelStyle),
      textAlign: TextAlign.right,
      textDirection: ui.TextDirection.ltr,
    );
    minPriceTextPainter.layout();
    minPriceTextPainter.paint(
        canvas,
        Offset(xOffset - minPriceTextPainter.width - 5,
            minPricePosition - minPriceTextPainter.height / 2));

    final List<Offset> points = [];
    for (int i = 0; i < priceEntries.length; i++) {
      final entry = priceEntries[i];
      final double x =
          xOffset + i * ((size.width - xOffset) / (priceEntries.length - 1));
      final double y = size.height -
          yOffset -
          (entry.price / maxPriceRounded * (size.height - yOffset - 20));
      points.add(Offset(x, y));
    }

    // Draw line connecting points
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw circles at each point
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 4, circlePaint);
    }

    for (int i = 0; i < points.length; i++) {
      final entry = priceEntries[i];
      final monthLabel = monthFormat.format(DateTime.parse(entry.priceDate));

      final monthTextPainter = TextPainter(
        text: TextSpan(text: monthLabel, style: labelStyle),
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );
      monthTextPainter.layout();
      monthTextPainter.paint(
          canvas, Offset(points[i].dx - 10, size.height - 35));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
