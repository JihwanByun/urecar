import 'package:flutter/material.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/landing_screen.dart';
import 'package:frontend/screens/setting_screen.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:frontend/components/common/spinner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  final MainController controller = Get.put(MainController());
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LoadingApp());

  final cameras = await availableCameras();
  CameraDescription? firstCamera;
  if (cameras.isNotEmpty) {
    firstCamera = cameras.first;
  } else {
    firstCamera = null;
  }
  controller.camera = firstCamera;
  await dotenv.load(fileName: 'assets/config/.env.development');
  runApp(
    const App(),
  );
  runApp(const App());
}

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Spinner(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Suit',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFA1E4E4),
        primaryColorLight: const Color(0xFFE3F7F7),
        cardColor: const Color(0xFFF2F3F5),
      ),
      initialRoute: '/landing',
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/camera', page: () => const CameraScreen()),
        GetPage(name: '/history', page: () => const HistoryScreen()),
        GetPage(name: '/setting', page: () => const SettingScreen()),
        GetPage(name: '/landing', page: () => LandingScreen())
      ],
    );
  }
}
