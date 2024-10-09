import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController {
  var fcmToken = "".obs;
  var accessToken = "".obs;
  var memberName = "".obs;
  var memberEmail = "".obs;
  var memberId = 0.obs;
  var memberRole = "".obs;
  var currentIndex = 10.obs;
  var pageStack = <int>[0].obs;
  var camera;

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        if (Get.currentRoute != '/home') {
          Get.offAllNamed('/home');
          break;
        }
      case 1:
        if (Get.currentRoute != '/camera') {
          Get.offAllNamed('/camera');
          break;
        }
      case 2:
        if (Get.currentRoute != '/history') {
          Get.offAllNamed('/history');
          break;
        }
      case 3:
        if (Get.currentRoute != '/setting') {
          Get.offAllNamed('/setting');
          break;
        }
    }
  }
}

class NotificationController extends GetxController {
  var notificationList = <String>[].obs;

  Future<void> addNotification(String? title, String? content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (title != null && content != null) {
      List<String>? storedNotifications = prefs.getStringList('notifications');
      storedNotifications ??= [];
      storedNotifications.add("$title:$content");
      await prefs.setStringList('notifications', storedNotifications);
    }
  }

  Future<void> removeNotification(String notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationList.remove(notification);
    await prefs.setStringList('notifications', notificationList);
  }

  Future<void> clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationList.clear();
    await prefs.remove('notifications');
  }

  Future<void> loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedNotifications = prefs.getStringList('notifications');
    if (storedNotifications != null) {
      notificationList.value = storedNotifications;
    }
  }
}
