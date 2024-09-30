import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/report_screen/report_screen_list_item.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final MainController controller = Get.put(MainController());
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(
          onNotificationPressed: () {
            controller.showNotification;
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(children: [
              Text(
                "24.07.01",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "정류장 불법 주정차 신고",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
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
            const ReportScreenListItem(
                title: "신고 일시", content: "24.07.01 14:00"),
            ReportScreenListItem(
              title: "진행 상황",
              content: "처리중",
              fontColor: Theme.of(context).primaryColor,
            ),
            ReportScreenListItem(
                title: isCompleted == true ? "2차 사진 촬영" : "신고 번호",
                content: isCompleted == true ? "가능" : "SPP-2042_1006454"),
            isCompleted == true
                ? Container()
                : Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 13,
                          ),
                          Text(
                            "처리 결과",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReportScreenListItem(
                        title: "처리 결과",
                        content: "수용",
                        fontColor: Theme.of(context).primaryColor,
                      ),
                      const ReportScreenListItem(title: "담당자", content: "백승우"),
                    ],
                  )
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
