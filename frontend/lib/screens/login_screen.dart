import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/signup_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final MainController controller = Get.put(MainController());
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final apiService = ApiService();
      try {
        await apiService.login(formData);
        controller.changePage(0);
      } catch (e) {
        Get.snackbar('오류', '회원가입 중 오류가 발생했습니다.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
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
            Input(
              controller: emailController,
              inputType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "이메일을 입력하세요.";
                }
                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                    .hasMatch(value)) {
                  return "유효한 이메일 주소를 입력하세요.";
                }
                return null;
              },
              onSaved: (value) {
                formData['email'] = value ?? '';
              },
            ),
            const InputLabel(name: "비밀번호"),
            Input(
              controller: passwordController,
              inputType: TextInputType.visiblePassword,
              obscure: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return "비밀번호는 6자 이상이어야 합니다.";
                }
                return null;
              },
              onSaved: (value) {
                formData['password'] = value ?? '';
              },
            ),
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
                onPressed: submitForm,
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
