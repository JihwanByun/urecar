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

  String? emailError;
  String? passwordError;

  void submitForm() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    bool isValid = true;

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "이메일을 입력하세요.";
      });
      isValid = false;
    } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
        .hasMatch(emailController.text)) {
      setState(() {
        emailError = "유효한 이메일 주소를 입력하세요.";
      });
      isValid = false;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      setState(() {
        passwordError = "비밀번호는 6자 이상이어야 합니다.";
      });
      isValid = false;
    }

    if (isValid) {
      formKey.currentState!.save();
      final apiService = ApiService();
      try {
        final res = await apiService.login(formData);
        if (res == 200) {
          controller.changePage(0);
        } else {
          Get.snackbar('오류', '$res', snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('오류', '로그인 중 오류가 발생했습니다.',
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
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset(
                'assets/images/logo.png',
                width: 350,
              ),
            ),
            const SizedBox(height: 50),
            const InputLabel(name: "이메일"),
            Input(
              controller: emailController,
              inputType: TextInputType.emailAddress,
              onSaved: (value) {
                formData['email'] = value ?? '';
              },
            ),
            if (emailError != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                child: Text(
                  emailError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const InputLabel(name: "비밀번호"),
            Input(
              controller: passwordController,
              inputType: TextInputType.visiblePassword,
              obscure: true,
              onSaved: (value) {
                formData['password'] = value ?? '';
              },
            ),
            if (passwordError != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                child: Text(
                  passwordError!,
                  style: const TextStyle(color: Colors.red),
                ),
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
