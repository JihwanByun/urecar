import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/report_screen/report_screen_content_input.dart';
import 'package:frontend/components/report_screen/report_screen_list_item.dart';
import 'package:frontend/components/report_screen/report_screen_timer_button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, dynamic> res;
  final bool? isSecond;

  const ReportScreen({super.key, required this.res, this.isSecond});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final MainController controller = Get.put(MainController());
  late bool isCompleted;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> result = widget.res;
    final Uint8List bitesImage = result.containsKey("firstImage")
        ? base64Decode(result["firstImage"])
        : base64Decode(result["secondImage"]);
    widget.isSecond == null ? isCompleted = true : isCompleted = false;
    void onButtonPressed() {
      Get.to(() => CameraScreen(
            reportId: result["reportId"],
            reportContent: _textController.text,
          ));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(children: [
                Text(
                  DateFormat('yy.MM.dd').format(result["date"]),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  result["type"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: 250,
                  child: Image.memory(
                    bitesImage,
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
                  title: isCompleted == false ? "2차 사진 촬영" : "신고 번호",
                  content: isCompleted == false ? "가능" : "SPP-2042_1006454"),
              isCompleted == false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "신고 내용",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReportScreenContentInput(controller: _textController),
                          ReportScreenTimerButton(
                              onButtonPressed: onButtonPressed)
                        ],
                      ),
                    )
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
                        const ReportScreenListItem(
                          title: "담당자",
                          content: "백승우",
                        ),
                      ],
                    ),
            ],
          ),
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
