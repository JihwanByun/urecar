import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/setting_screen/setting_screen_item.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(
          onNotificationPressed: () {
            controller.showNotification;
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.0, // 전체 크기 (테두리 포함)
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black, // 테두리 색상
                            width: 2.0, // 테두리 두께
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 35,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "김 혁",
                              style:
                                  TextStyle(fontSize: 28, color: Colors.black),
                            ),
                            Text("정보 수정")
                          ],
                        ),
                      )
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 40,
                  )
                ],
              ),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
            ),
            const Column(
              children: [
                SettingScreenItem(title: "알림 설정"),
                SettingScreenItem(title: "고객센터"),
                SettingScreenItem(title: "나의 신고"),
                SettingScreenItem(title: "내 저장소"),
                SettingScreenItem(title: "회원 탈퇴"),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
