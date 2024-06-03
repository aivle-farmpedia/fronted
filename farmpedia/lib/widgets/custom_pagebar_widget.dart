import 'package:flutter/material.dart';

class CustomPagebar extends StatelessWidget {
  final TabController? controller;
  final Color? nonSelectedColor;
  final Color? selectedColor;

  const CustomPagebar({
    super.key,
    required this.controller,
    this.nonSelectedColor,
    this.selectedColor,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller?.length ?? 0,
        (index) => AnimatedBuilder(
          animation: controller!,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: controller?.index == index
                    ? selectedColor
                    : nonSelectedColor,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ),
    );
  }
}
