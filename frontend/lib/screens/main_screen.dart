import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/landing_screen.dart';
import 'package:frontend/screens/notification_screen.dart';
import 'package:frontend/screens/setting_screen.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const CameraScreen(),
    const HistoryScreen(),
    const SettingScreen(),
  ];
  bool showNotification = false;
  bool showLanding = true;

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(
          onNotificationPressed: () {
            controller.showNotification;
          },
        ),
      ),
      body: Obx(() {
        if (controller.showLanding.value) {
          return LandingScreen();
        } else if (controller.showNotification.value) {
          return const NotificationScreen();
        } else {
          return IndexedStack(
            index: controller.currentIndex.value,
            children: screens,
          );
        }
      }),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: (int index) {
          controller.changePage(index);
          setState(() {
            currentIndex = controller.currentIndex.value;
          });
        },
      ),
    );
  }
}
