import 'package:get/get.dart';
import 'package:camera/camera.dart';

class MainController extends GetxController {
  var currentIndex = 10.obs; // 현재 탭 인덱스
  var pageStack = <int>[0].obs; // 페이지 스택 (초기 홈 화면)
  var showNotification = false.obs; // 알림 페이지 상태
  var showLanding = true.obs; // 랜딩 페이지 상태
  var camera;
  // 페이지 변경 메서드
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

  // 알림 페이지 전환 메서드
  void showNotificationPage() {
    showNotification.value = true;
  }
}
