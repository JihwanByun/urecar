import 'package:get/get.dart';
import 'package:camera/camera.dart';

class MainController extends GetxController {
  var currentIndex = 10.obs;
  var pageStack = <int>[0].obs;
  var showNotification = false.obs;
  var showLanding = true.obs;
  var camera;

  void changePage(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      switch (index) {
        case 0:
          Get.offAllNamed('/home');
          break;
        case 1:
          Get.offAllNamed('/camera');
          break;
        case 2:
          Get.offAllNamed('/history');
          break;
        case 3:
          Get.offAllNamed('/setting');
          break;
      }
    }
  }

  void showNotificationPage() {
    showNotification.value = true;
  }
}
