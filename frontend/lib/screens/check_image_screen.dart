import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
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

    sendImage() async {
      Map<String, dynamic> formData = {
        'dto': {
          "memberId": controller.memberId.value,
          "latitude": latitude,
          "longitude": longitude
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
          Get.to(() => ReportScreen(
                res: res,
                isSecond: true,
              ));
        }
      } catch (e) {
        Get.snackbar('오류', "$e", snackPosition: SnackPosition.BOTTOM);
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
          Get.to(() => ReportScreen(
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
