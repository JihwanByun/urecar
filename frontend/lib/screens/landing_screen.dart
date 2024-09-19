import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:get/get.dart';

class LandingScreen extends StatelessWidget {
  LandingScreen({super.key});
  final MainController controller = Get.put(MainController());

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
            Button(
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
            const SizedBox(
              height: 30,
            ),
            Button(
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
            Button(
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
          ],
        ),
      ),
    );
  }
}
