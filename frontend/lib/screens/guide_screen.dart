import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

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
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/guide_image.png"),
          ],
        ),
      )),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
