import 'package:flutter/material.dart';
import 'package:frontend/components/notification_screen/notification_screen_cart.dart';
import 'package:frontend/services/api_service.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final apiService = ApiService();
  dynamic notifications = [];
  Future<void> _loadNotifications() async {
    final response = await apiService.findNotifications();
    print(response);

    notifications = response;
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: notifications.isEmpty
          ? const Center(child: Text("알림이 없습니다."))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: NotificationScreenCart(content: "1"),
                );
              },
            ),
    );
  }
}
