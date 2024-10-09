import 'package:flutter/material.dart';
import 'package:frontend/screens/notification_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Image.asset(
        'assets/images/logo.png',
        width: 110,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
              iconSize: 28,
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Get.to(() => const NotificationScreen());
              }),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }
}
