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
  String textError = "";
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> result = widget.res;
    final Uint8List bitesImage = result.containsKey("firstImage")
        ? base64Decode(result["firstImage"])
        : base64Decode(result["secondImage"]);
    widget.isSecond == null ? isCompleted = true : isCompleted = false;

    DateTime dateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(result["datetime"]);
    String date = DateFormat('yy.MM.dd').format(dateTime);
    String datetime = DateFormat('yy.MM.dd HH:mm').format(dateTime);
    void onButtonPressed() {
      if (_textController.text == "") {
        setState(() {
          textError = "신고 내용을 작성해주세요,";
        });
      } else {
        Get.to(() => CameraScreen(
              reportId: result["reportId"],
              reportContent: _textController.text,
            ));
      }
    }

    List<String> statusList = [
      'ONGOING',
      'ANALYSIS_SUCCESS',
      'ACCEPTED',
      'UNDACCEPTED',
      'CANCELLED_FIRST_FAILED',
      'CANCELLED_SECOND_FAILED',
    ];
    List<String> stautsListKorean = [
      '분석중',
      '심사중',
      '수용',
      '불수용',
      '요건 불충족',
      '검증 실패',
    ];
    int idx = statusList.indexOf(result["processStatus"]);
    List<Color> ColorList = [
      Colors.blue.shade600,
      Colors.blue.shade600,
      Theme.of(context).primaryColor,
      const Color(0x0fe32222),
      const Color(0x0fe32222),
      const Color(0x0fe32222)
    ];

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
                  date,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  result["type"] ?? '미지정',
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
              ReportScreenListItem(
                  title: "분류", content: result["type"] ?? "미지정"),
              ReportScreenListItem(title: "신고 일시", content: datetime),
              ReportScreenListItem(
                title: "진행 상황",
                content: stautsListKorean[idx],
                fontColor: ColorList[idx],
              ),
              ReportScreenListItem(
                  title: isCompleted == false ? "2차 사진 촬영" : "신고 번호",
                  content: isCompleted == false
                      ? "가능"
                      : "SPP-2042_${result["reportId"]}"),
              isCompleted == true
                  ? ReportScreenListItem(
                      title: "담당자",
                      content: result["officialName"] ?? "지정중",
                    )
                  : Container(),
              isCompleted == false
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
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
                        Row(
                          children: [
                            Text(
                              textError,
                              style: const TextStyle(color: Color(0xffe32222)),
                            )
                          ],
                        ),
                        ReportScreenTimerButton(
                          onButtonPressed: onButtonPressed,
                          seconds:
                              dateTime.difference(DateTime.now()).inSeconds -
                                  32400,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "신고 내용",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 350,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  result["content"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
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
