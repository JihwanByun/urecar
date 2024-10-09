import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/report_screen/report_screen_list_item.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const HistoryDetailScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    bool isCompleted = reportData['status'] == '수용';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  reportData['date'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  reportData['title'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 400,
                child: Image.asset(
                  "assets/images/busstop_guide_image.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const ReportScreenListItem(title: "분류", content: "불법 주정차"),
            ReportScreenListItem(
                title: "신고 일시", content: "${reportData['date']} 14:00"),
            ReportScreenListItem(
              title: "진행 상황",
              content: reportData['status'],
              fontColor: reportData['color'],
            ),
            ReportScreenListItem(
                title: isCompleted ? "2차 사진 촬영" : "신고 번호",
                content: isCompleted ? "가능" : "SPP-2042_1006454"),
            if (!isCompleted)
              Column(
                children: [
                  const SizedBox(height: 25),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 13),
                      Text(
                        "처리 결과",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ReportScreenListItem(
                    title: "처리 결과",
                    content: "수용",
                    fontColor: Theme.of(context).primaryColor,
                  ),
                  const ReportScreenListItem(title: "담당자", content: "백승우"),
                ],
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
