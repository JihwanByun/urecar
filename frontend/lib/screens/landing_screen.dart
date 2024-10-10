import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:get/get.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final MainController controller = Get.put(MainController());
  static const storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncMethod();
    });
  }

  Future<void> asyncMethod() async {
    final userInfo = await storage.read(key: "login");
    if (userInfo != null) {
      List<String> userInfoList = userInfo.split(' ');
      setState(() {
        controller.memberEmail.value = userInfoList[0];
        controller.accessToken.value = userInfoList[1];
        controller.memberId.value = int.parse(userInfoList[2]);
        controller.memberName.value = userInfoList[3];
        controller.memberRole.value = userInfoList[4];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 350,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 350,
              child: Button(
                text: "사진 촬영",
                onPressed: () {
                  controller.changePage(1);
                },
                horizontal: 90,
                vertical: 80,
                fontSize: 30,
                icon: Icons.camera_alt_outlined,
                iconSize: 60,
                backgroundColor: Theme.of(context).primaryColorLight,
                contentColor: Colors.black,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 350,
              child: Button(
                text: "메인으로",
                onPressed: () {
                  controller.changePage(0);
                },
                horizontal: 95,
                vertical: 20,
                fontSize: 30,
                backgroundColor: Theme.of(context).primaryColorLight,
                contentColor: Colors.black,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            controller.memberId.value == 0
                ? SizedBox(
                    width: 350,
                    child: Button(
                      text: "로그인",
                      onPressed: () {
                        Get.to(const LoginScreen());
                      },
                      horizontal: 95,
                      vertical: 20,
                      fontSize: 30,
                      backgroundColor: Theme.of(context).primaryColorLight,
                      contentColor: Colors.black,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
