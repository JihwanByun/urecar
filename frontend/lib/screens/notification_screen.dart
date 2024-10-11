import 'package:flutter/material.dart';
import 'package:frontend/components/notification_screen/notification_screen_card.dart';
import 'package:frontend/screens/report_screen.dart';
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
  bool isLoading = true;
  Future<void> _loadNotifications() async {
    final response = await apiService.findNotifications();
    setState(() {
      notifications = response;
      isLoading = false;
    });
  }

  void removeNotification(int idx) {
    setState(() {
      apiService.removeNotification(notifications[idx]["notificationId"]);
      notifications.removeAt(idx);
    });
  }

  void removeAllNotifications() {
    setState(() {
      apiService.removeAllNotifications();
      notifications = [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> navigateToDetailScreen(String reportId) async {
    final response = await apiService.findSpecificReport(reportId);

    if (response != null && response is Map<String, dynamic>) {
      if (["ONGOING", "FIRST_ANALYSIS_SUCCESS"]
          .contains(response["processStatus"])) {
        Get.to(() => ReportScreen(
              res: response,
              isSecond: true,
            ));
      } else {
        Get.to(() => ReportScreen(res: response));
      }
    } else {
      Get.snackbar(
        "오류",
        "신고 세부 정보를 불러오는 중 문제가 발생했습니다.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(child: Text("알림이 없습니다."))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 100,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(top: 20),
                                  minimumSize: const Size(0, 30),
                                  splashFactory: NoSplash.splashFactory,
                                ),
                                onPressed: removeAllNotifications,
                                child: const Text(
                                  "모두 삭제",
                                  style: TextStyle(color: Colors.black),
                                )),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: NotificationScreenCard(
                                    content: notifications[index]["content"],
                                    onRemoveButtonPressed: () =>
                                        removeNotification(index),
                                    datetime: notifications[index]["datetime"],
                                    onTextTap: () => navigateToDetailScreen(
                                        notifications[index]["reportId"]
                                            .toString())));
                          },
                        ),
                      )
                    ],
                  ));
  }
}
