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
        return Navigator(
          onGenerateRoute: (settings) {
            switch (controller.currentIndex.value) {
              case 0:
                return GetPageRoute(
                  settings: settings,
                  page: () => const HomeScreen(),
                );
              case 1:
                return GetPageRoute(
                  settings: settings,
                  page: () => const CameraScreen(),
                );
              case 2:
                return GetPageRoute(
                  settings: settings,
                  page: () => const HistoryScreen(),
                );
              case 3:
                return GetPageRoute(
                  settings: settings,
                  page: () => const SettingScreen(),
                );
              default:
                return GetPageRoute(
                  settings: settings,
                  page: () => const HomeScreen(),
                );
            }
          },
        );
      }),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
