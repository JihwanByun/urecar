import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset(
                'assets/images/logo.png',
                width: 350,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const InputLabel(name: "이메일"),
            const Input(),
            const InputLabel(name: "비밀번호"),
            const Input(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.to(() => const SignupScreen());
                  },
                  child: const Text(
                    "회원가입",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const Text("ㅣ"),
                TextButton(
                  onPressed: () {
                    Get.to(const SignupScreen());
                  },
                  child: const Text(
                    "ID/PW 찾기",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Button(
                text: "로그인",
                onPressed: () {},
                horizontal: 100,
                vertical: 10,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
