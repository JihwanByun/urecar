import 'package:flutter/material.dart';
import 'package:frontend/components/common/input.dart';
import 'package:frontend/components/common/input_label.dart';

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
            const InputLabel(name: "아이디"),
            const Input(),
            const InputLabel(name: "비밀번호"),
            const Input(),
          ],
        ),
      ),
    );
  }
}
