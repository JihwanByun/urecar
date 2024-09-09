import 'package:flutter/material.dart';
import 'package:frontend/screens/notification_screen.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onNotificationPressed;

  const TopBar({super.key, required this.onNotificationPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text(
        "우리로고?",
        style: TextStyle(fontSize: 24),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            iconSize: 28,
            icon: const Icon(Icons.notifications),
            onPressed: onNotificationPressed,
          ),
        ),
      ],
    );
  }
}
