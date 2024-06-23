import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/policy_api_service.dart';
import 'package:farmpedia/models/policy_model.dart';
import 'package:farmpedia/widgets/backpage_widget.dart';
import 'package:farmpedia/widgets/menu_widget.dart';

class PolicyScreen extends StatefulWidget {
  final String id;
  final int privateId;
  const PolicyScreen({
    super.key,
    required this.id,
    required this.privateId,
  });

  @override
  _PolicyScreenState createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  late Future<List<PolicyBoard>> futurePolicies;
  int currentPage = 1;
  bool isLoadingMore = false;
  List<PolicyBoard> allBoards = [];
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    futurePolicies = fetchPolicies(currentPage);
  }

  Future<List<PolicyBoard>> fetchPolicies(int page) async {
    try {
      Map<String, dynamic> fetchedData =
          await PolicyApiService().getPolicyList(widget.id, page);

      // Extract policies from fetchedData
      List<PolicyBoard> policies = List<PolicyBoard>.from(fetchedData['data']
          .map((policyJson) => PolicyBoard.fromJson(policyJson)));

      setState(() {
        totalPages = fetchedData['totalPages'];
      });

      return policies;
    } catch (e) {
      throw Exception('Failed to load boards');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          backgroundColor: const Color.fromARGB(255, 241, 240, 240),
          title: const Text(
            "지원 정책",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
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
              child: FutureBuilder<List<PolicyBoard>>(
                future: futurePolicies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('사용 가능한 정책이 없습니다'));
                  } else {
                    final policies = snapshot.data!;
                    return Text(
                      "총 ${policies.length}건의 데이터",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<PolicyBoard>>(
                future: futurePolicies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('사용 가능한 정책이 없습니다'));
                  } else {
                    final policies = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: policies.length,
                      itemBuilder: (context, index) {
                        final policy = policies[index];
                        return Column(
                          children: [
                            SupportCard(
                              title: policy.title,
                              subtitle: policy.title,
                              color: Colors.lightGreen,
                              icon: Icons.spa,
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
          ],
        ),
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final double height;
  final double titleFontSize;
  final double subtitleFontSize;
  final double iconSize;

  const SupportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.height = 100.0,
    this.titleFontSize = 23.0,
    this.subtitleFontSize = 16.0,
    this.iconSize = 47.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExampleScreen(title: title),
          ),
        );
      },
      child: SizedBox(
        height: height,
        child: Card(
          color: color,
          child: ListTile(
            leading: Icon(
              icon,
              size: iconSize,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontSize: subtitleFontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  final String title;

  const ExampleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Example Screen for $title'),
      ),
    );
  }
}


// void main() {
//   runApp(const PolicyScreen(id:id));
// }
