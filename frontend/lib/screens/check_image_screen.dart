import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/report_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CheckImageScreen extends StatelessWidget {
  final XFile image;
  final double longitude;
  final double latitude;
  const CheckImageScreen({
    super.key,
    required this.image,
    required this.longitude,
    required this.latitude,
  });

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    Map<String, dynamic> formData = {
      'dto': {
        "memberId": controller.memberId.value,
        "latitude": latitude,
        "longitude": longitude
      }
    };
    sendPicture() async {
      final apiService = ApiService();
      try {
        final res = await apiService.createReport(formData, image);
        if (res == 200) {
          Get.to(() => const ReportScreen());
        } else {
          Get.snackbar('오류', '${res["message"]}',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('오류', '사진 전송 중 오류가 발생했습니다. 잠시 후 다시 이용해주세요.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }

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
      body: Column(
        children: [
          Image.file(
            File(image.path),
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
                    onPressed: sendPicture,
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
    );
  }
}
