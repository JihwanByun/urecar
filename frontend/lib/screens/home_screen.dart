import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/home_screen/home_screen_image_card.dart';
import 'package:frontend/screens/guide_screen.dart';
import 'package:frontend/screens/safety_news_screen.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/services/api_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int reportCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final apiService = ApiService();
    final MainController controller = Get.put(MainController());
    final String memberId = controller.memberId.value.toString();
    final String startDateFormatted = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 92)));
    final String endDateFormatted =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await apiService.findReports(
      memberId,
      startDateFormatted,
      endDateFormatted,
      null,
    );

    setState(() {
      if (response is List) {
        reportCount = response.length;
      } else {
        reportCount = 0;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 27.0,
                      vertical: 20,
                    ),
                    child: Text(
                      "${controller.memberName.value != "" ? controller.memberName.value : "Guest"}님, 안녕하세요!",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ScreenCard(
                    title: "나의 신고 현황",
                    contents: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$reportCount",
                            style: const TextStyle(
                              color: Color(0xffe32222),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            " 건",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const HomeScreenImageCard(
                    imageLink: "assets/images/guide_link.png",
                    screen: GuideScreen(),
                    title: "신고 가이드 보러 가기",
                  ),
                  const HomeScreenImageCard(
                    imageLink: "assets/images/safety_news.png",
                    screen: SafetyNewsScreen(),
                    title: "안전 뉴스 보러 가기",
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
