import 'package:flutter/material.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatelessWidget {
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      currentIndex: controller.currentIndex.value,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_rounded,
            size: 25,
          ),
          label: "홈",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera_alt,
            size: 25,
          ),
          label: "신고",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.description,
            size: 25,
          ),
          label: "내역",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_pin_rounded,
            size: 25,
          ),
          label: "마이",
        ),
      ],
    );
  }
}
