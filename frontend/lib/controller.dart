import 'package:get/get.dart';

class MainController extends GetxController {
  var fcmToken = "".obs;
  var accessToken = "".obs;
  var memberName = "".obs;
  var memberEmail = "".obs;
  var memberId = 0.obs;
  var memberRole = "".obs;
  var currentIndex = 10.obs;
  var pageStack = <int>[0].obs;
  var receiveNotification = false.obs;
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
