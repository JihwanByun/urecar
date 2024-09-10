import 'package:get/get.dart';

class MainController extends GetxController {
  var currentIndex = 0.obs; // 현재 탭 인덱스
  var pageStack = <int>[0].obs; // 페이지 스택 (초기 홈 화면)
  var showNotification = false.obs; // 알림 페이지 상태
  var showLanding = true.obs; // 랜딩 페이지 상태

  // 페이지 변경 메서드
  void changePage(int index) {
    currentIndex.value = index;
    showNotification.value = false;
    showLanding.value = false;
  }

  // 알림 페이지 전환 메서드
  void showNotificationPage() {
    showNotification.value = true;
  }
}
