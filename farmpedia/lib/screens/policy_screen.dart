import 'package:farmpedia/models/support_policy.dart';
import 'package:farmpedia/screens/policy_view.dart';
import 'package:farmpedia/widgets/paging_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/policy_api_service.dart';
import 'package:farmpedia/models/policy_model.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';

class PolicyScreen extends StatefulWidget {
  final int id;
  final String privateId;
  final String category;
  const PolicyScreen({
    super.key,
    required this.id,
    required this.privateId,
    required this.category,
  });

  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  late Future<Map<String, dynamic>> futurePolicies;
  int currentPage = 1;
  bool isLoadingMore = false;
  List<PolicyBoard> allBoards = [];
  int totalPages = 1;
  String category = "ALL";

  @override
  void initState() {
    super.initState();
    futurePolicies = fetchPolicies(currentPage, category);
  }

  void _onCategoryChanged(String categoryType) {
    setState(() {
      category = categoryType;
      futurePolicies = fetchPolicies(currentPage, category);
    });
  }

  void _onPageChange(int page) {
    setState(() {
      futurePolicies = fetchPolicies(page, category);
    });
  }

  Future<Map<String, dynamic>> fetchPolicies(int page, String category) async {
    try {
      Map<String, dynamic> fetchedData = await PolicyApiService()
          .getPolicyList(widget.privateId, page, category);

      setState(() {
        totalPages = fetchedData['totalPages'];
      });

      return fetchedData;
    } catch (e) {
      throw Exception('Failed to load boards');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF95c452),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 167, 212, 103), // Button color
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: BackpageWidget(
            beforeContext: context,
          ),
          actions: [
            MenuWidget(
              id: widget.id,
              privateId: widget.privateId,
            )
          ],
          backgroundColor: const Color(0xFF95c452),
          title: const Text(
            "지원 정책",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'GmarketSans',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<Map<String, dynamic>>(
                future: futurePolicies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!['policyboards'].isEmpty) {
                    return const Center(child: Text('사용 가능한 정책이 없습니다'));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _onCategoryChanged("ALL"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: category == "ALL"
                                    ? Colors.green
                                    : const Color.fromARGB(255, 167, 212, 103),
                              ),
                              child: const Text(
                                '전체',
                                style: TextStyle(
                                  fontFamily: 'GmarketSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _onCategoryChanged("BUSINESS"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: category == "BUSINESS"
                                    ? Colors.green
                                    : const Color.fromARGB(255, 167, 212, 103),
                              ),
                              child: const Text(
                                '사업',
                                style: TextStyle(
                                  fontFamily: 'GmarketSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _onCategoryChanged("EDUCATION"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: category == "EDUCATION"
                                    ? Colors.green
                                    : const Color.fromARGB(255, 167, 212, 103),
                              ),
                              child: const Text(
                                '교육',
                                style: TextStyle(
                                  fontFamily: 'GmarketSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: futurePolicies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!['policyboards'].isEmpty) {
                    return const Center(child: Text('사용 가능한 정책이 없습니다'));
                  } else {
                    final policies =
                        snapshot.data!['policyboards'] as List<PolicyBoard>;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: policies.length,
                      itemBuilder: (context, index) {
                        final policy = policies[index];
                        return Column(
                          children: [
                            SupportCard(
                              policy: policy,
                              color: const Color(0xFF95c452),
                              icon: Icons.spa,
                              id: widget.id,
                              privateId: widget.privateId,
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            PagingWidget(
              totalPages: totalPages,
              onPageChange: _onPageChange,
            )
          ],
        ),
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final PolicyBoard policy;
  final Color color;
  final IconData icon;
  final double height;
  final double titleFontSize;
  final double subtitleFontSize;
  final double iconSize;
  final int id;
  final String privateId;

  const SupportCard({
    super.key,
    required this.policy,
    required this.color,
    required this.icon,
    required this.id,
    required this.privateId,
    this.height = 100.0,
    this.titleFontSize = 23.0,
    this.subtitleFontSize = 16.0,
    this.iconSize = 47.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          SupportPolicy supportPolicy =
              await PolicyApiService().getPolicyDetails(policy.id, privateId);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PolicyView(supportPolicy: supportPolicy)),
          );
        } catch (e) {
          // 오류 처리
          print('Failed to load policy details: $e');
        }
      },
      child: Expanded(
        child: SizedBox(
          height: height,
          child: Card(
            color: color,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 16.0),
                Icon(
                  icon,
                  size: iconSize,
                  color: const Color.fromARGB(255, 79, 113, 69),
                ),
                const SizedBox(height: 8.0),
                const SizedBox(width: 16.0),
                Text(
                  policy.title.length > 10
                      ? '${policy.title.substring(0, 10)}...'
                      : policy.title,
                  style: TextStyle(
                    fontFamily: 'GmarketSans',
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
