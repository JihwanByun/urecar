import 'package:flutter/material.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    loadNotificationsData();
  }

  Future<void> loadNotificationsData() async {
    await notificationController.loadNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<String> notifications = notificationController.notificationList;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: notifications.isEmpty
          ? const Center(child: Text("알림이 없습니다."))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    notifications[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
