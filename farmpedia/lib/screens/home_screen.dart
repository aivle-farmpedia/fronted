import 'package:farmpedia/services/image_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Color mainColor = const Color(0xff95C461);

  final Future<List<String>> images = ImageSerivce.getImageList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        title: const Text(
          '귀농백과',
          style: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: imageList(images),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      child: Text('시작하기'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder imageList(Future<List<String>> images) {
    return FutureBuilder(
      future: images,
      builder: (context, snapshot) {
        List<String> imagePaths = snapshot.data ?? [];
        // print(imagePaths);
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return Image.asset(imagePaths[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(
            width: 20,
          ),
        );
      },
    );
  }
}
