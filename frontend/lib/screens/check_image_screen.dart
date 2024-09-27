import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:get/get.dart';

class CheckImageScreen extends StatefulWidget {
  final String imagePath;
  const CheckImageScreen({super.key, required this.imagePath});

  @override
  State<CheckImageScreen> createState() => _CheckImageScreenState();
}

class _CheckImageScreenState extends State<CheckImageScreen> {
  int totalSeconds = 6000;
  bool isRunning = false;
  late Timer timer;
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  void onStart() {
    timer = Timer.periodic(const Duration(milliseconds: 10), onTick);
    setState(() {
      isRunning = true;
    });
  }

  @override
  void initState() {
    onStart();
    super.initState();
  }

  String formatTime() {
    int seconds = (totalSeconds / 100).floor();
    int milliseconds = totalSeconds % 100;
    return '${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (isRunning == true) {
      isRunning = false;
      timer.cancel();
    }
    super.dispose();
  }

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
          Stack(children: [
            Image.file(
              File(widget.imagePath),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    formatTime(),
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  )),
            )
          ]),
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
