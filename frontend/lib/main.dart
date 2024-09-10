import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFA1E4E4),
        primaryColorLight: const Color(0xFFE3F7F7),
        cardColor: const Color(0xFFF2F3F5),
      ),
      home: const MainScreen(),
    );
  }
}
