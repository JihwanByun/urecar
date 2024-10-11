import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/report_screen/report_screen_content_input.dart';
import 'package:frontend/components/report_screen/report_screen_list_item.dart';
import 'package:frontend/components/report_screen/report_screen_timer_button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/services/api_service.dart';
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
  final apiService = ApiService();
  late Timer _statusTimer = Timer(const Duration(seconds: 0), () {});
  String secondPossible = "불가능";

  @override
  void initState() {
    super.initState();
    if (widget.res["processStatus"] == "ONGOING") {
      startStatusTimer();
    }
  }

  void startStatusTimer() {
    const duration = Duration(seconds: 5);
    _statusTimer = Timer.periodic(duration, (Timer timer) async {
      await fetchStatus();
    });
  }

  Future<void> fetchStatus() async {
    try {
      final response = await apiService
          .findSpecificReport(widget.res["reportId"].toString());
      if (response["processStatus"] != "ONGOING") {
        if (mounted) {
          setState(() {
            widget.res["processStatus"] = response["processStatus"];
          });
        }
        _statusTimer.cancel();
      }
    } catch (e) {
      Get.snackbar('오류', '신고 정보를 분석 중 오류가 발생했습니다. 잠시 후 다시 이용해주세요.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    if (_statusTimer.isActive) {
      _statusTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> result = widget.res;
    final Uint8List bitesImage = base64Decode(result["firstImage"]);
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
        if (secondPossible == "가능") {
          Get.to(() => CameraScreen(
                reportId: result["reportId"],
                reportContent: _textController.text,
              ));
        }
      }
    }

    List<String> statusList = [
      'ONGOING',
      'FIRST_ANALYSIS_SUCCESS',
      'CANCELLED_FIRST_FAILED',
      'CANCELLED_SECOND_FAILED',
      'ANALYSIS_SUCCESS',
      'ACCEPTED',
      'UNACCEPTED',
    ];

    List<String> statusListKorean = [
      '1차 사진 분석중',
      '1차 사진 분석 완료',
      '1차 사진 요건 불충족',
      '2차 사진 요건 불충족',
      '심사중',
      '수용',
      '불수용',
    ];
    int idx = statusList.indexOf(result["processStatus"]);
    List<Color> colorList = [
      Colors.blue.shade600,
      Colors.blue.shade600,
      const Color(0xffe32222),
      const Color(0xffe32222),
      Colors.blue.shade600,
      Theme.of(context).primaryColor,
      const Color(0xffe32222)
    ];
    bool secondTimer = false;
    void updateSecondPossible(bool isEnabled) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            secondTimer = isEnabled;
            if (secondTimer &&
                ["CANCELLED_FIRST_FAILED"].contains(result["processStatus"]) ==
                    false) {
              secondPossible = "가능";
            } else {
              secondPossible = "불가능";
            }
          });
        }
      });
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
                content: statusListKorean[idx],
                fontColor: colorList[idx],
              ),
              ReportScreenListItem(
                  title: isCompleted == false ? "2차 사진 촬영" : "신고 번호",
                  fontColor: isCompleted == false
                      ? secondPossible == "가능"
                          ? Colors.blue.shade600
                          : const Color(0xFFE32222)
                      : Colors.black,
                  content: isCompleted == false
                      ? secondPossible
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
                        result["processStatus"] != "CANCELLED_FIRST_FAILED"
                            ? ReportScreenTimerButton(
                                onButtonPressed: onButtonPressed,
                                seconds: DateTime.now()
                                    .difference(dateTime)
                                    .inSeconds,
                                onEnabledChanged: updateSecondPossible,
                              )
                            : const SizedBox()
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
                                  result["content"] ?? '내용없음',
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
