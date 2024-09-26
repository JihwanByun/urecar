import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/screen_card.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/home_screen/home_screen_image_card.dart';
import 'package:frontend/screens/guide_screen.dart';
<<<<<<< frontend/lib/screens/home_screen.dart
import 'package:frontend/screens/safety_news_screen.dart';
import 'package:frontend/screens/login_screen.dart';
>>>>>>> frontend/lib/screens/home_screen.dart
import 'package:get/get.dart';
import 'package:frontend/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 27.0,
                vertical: 20,
              ),
              child: Text(
                "${controller.userName.value != "" ? controller.userName.value : "Guest"}님, 안녕하세요!",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              )),
          const Column(
            children: [
              ScreenCard(title: "나의 신고 현황", contents: [
                Text(
                  "100",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Text(
                  " 건",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ]),
              HomeScreenImageCard(
                  imageLink: "assets/images/guide_link.png",
                  screen: GuideScreen(),
                  title: "신고 가이드 보러 가기"),
              HomeScreenImageCard(
                  imageLink: "assets/images/safety_news.png",
                  screen: SafetyNewsScreen(),
                  title: "안전 뉴스 보러 가기")
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
