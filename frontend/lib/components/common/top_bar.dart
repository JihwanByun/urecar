import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onNotificationPressed;

  const TopBar({super.key, required this.onNotificationPressed});

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
            onPressed: onNotificationPressed,
          ),
        ),
      ],
    );
  }
}
