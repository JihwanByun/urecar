import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:get/get.dart';

class CheckImageScreen extends StatelessWidget {
  final String imagePath;
  const CheckImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

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
                      Get.to(const CameraScreen());
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
                  width: 10, // 두 버튼 사이의 간격
                  child: Center(
                    child: Container(
                      width: 1, // 선의 두께
                      height: 55, // 선의 높이
                      color: Colors.black, // 선의 색상
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.to(const CameraScreen());
                    },
                    child: const Text(
                      "재촬영",
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
