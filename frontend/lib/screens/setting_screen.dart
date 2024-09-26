import 'package:flutter/material.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/components/setting_screen/setting_screen_item.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/preparation_screen.dart';
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
              child: GestureDetector(
                onTap: () {
                  Get.to(() => controller.userName.value != ""
                      ? const PreparationScreen()
                      : const LoginScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.userName.value != ""
                                    ? controller.userName.value
                                    : "로그인",
                                style: const TextStyle(
                                    fontSize: 28, color: Colors.black),
                              ),
                              controller.userName.value != ""
                                  ? const Text("정보 수정")
                                  : Container()
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
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
            ),
            const Column(
              children: [
                SettingScreenItem(
                  title: "알림 설정",
                  screen: PreparationScreen(),
                ),
                SettingScreenItem(
                  title: "고객센터",
                  screen: PreparationScreen(),
                ),
                SettingScreenItem(
                  title: "나의 신고",
                  screen: PreparationScreen(),
                ),
                SettingScreenItem(
                  title: "내 저장소",
                  screen: PreparationScreen(),
                ),
                SettingScreenItem(
                  title: "회원 탈퇴",
                  screen: PreparationScreen(),
                ),
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
