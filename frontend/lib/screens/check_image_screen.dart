import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/report_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:get/get.dart';

class CheckImageScreen extends StatelessWidget {
  final String imagePath;
  final double longitude;
  final double latitude;
  final int? reportId;
  final String? reportContent;

  const CheckImageScreen(
      {super.key,
      required this.imagePath,
      required this.longitude,
      required this.latitude,
      this.reportId,
      this.reportContent});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    String? selectedOption;
    List<String> options = [
      '소화전 불법주정차',
      '교차로 불법주정차',
      '인도 불법주정차',
      '횡단보도 불법주정차',
      '어린이 보호구역 불법주정차',
      '정류소 불법주정차'
    ];

    sendImage() async {
      if (controller.memberId.value == 0) {
        Get.to(() => LoginScreen(
            imagePath: imagePath, longitude: longitude, latitude: latitude));
      } else {
        String? result = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text('신고 유형을 선택하세요'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((option) {
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, selectedOption);
                      },
                      child: const Text('확인'),
                    ),
                  ],
                );
              },
            );
          },
        );
        if (result != null) {
          Map<String, dynamic> formData = {
            'dto': {
              "memberId": controller.memberId.value,
              "latitude": latitude,
              "longitude": longitude,
              "type": result
            }
          };
          final apiService = ApiService();
          try {
            final Map<String, dynamic> res =
                await apiService.createReport(formData, imagePath);
            if (res.containsKey("message")) {
              Get.snackbar('오류', res["message"],
                  snackPosition: SnackPosition.BOTTOM);
            } else {
              Get.off(() => ReportScreen(
                    res: res,
                    isSecond: true,
                  ));
            }
          } catch (e) {
            Get.snackbar('오류', "신고 도중 오류가 발생하였습니다. 잠시후 다시 시도해주세요.",
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('신고 불가능', "신고 유형을 선택해주세요.",
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    }

    sendSecondImage() async {
      Map<String, dynamic> formData = {
        'dto': {
          "memberId": controller.memberId.value,
          "latitude": latitude,
          "longitude": longitude,
          "reportId": reportId,
          "content": reportContent
        }
      };
      final apiService = ApiService();
      try {
        final Map<String, dynamic> res =
            await apiService.sendSecondImage(formData, imagePath);

        if (res.containsKey("message")) {
          Get.snackbar('오류', res["message"],
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.off(() => ReportScreen(
                res: res,
              ));
        }
      } catch (e) {
        Get.snackbar('오류', '사진 전송 중 오류가 발생했습니다. 잠시 후 다시 이용해주세요.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: TopBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(imagePath),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        controller.changePage(1);
                      },
                      child: const Text(
                        "취소",
                        style: TextStyle(
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    child: Center(
                      child: Container(
                        width: 1,
                        height: 55,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: reportId == null ? sendImage : sendSecondImage,
                      child: const Text(
                        "확인",
                        style: TextStyle(
                          fontSize: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
