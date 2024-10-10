import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/camera_screen.dart';
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/landing_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/setting_screen.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:frontend/components/common/spinner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/screens/officer_screen.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const LoadingApp());
  void checkPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.camera.isDenied) {
      await Permission.location.request();
    }
  }

  checkPermissions();
  final cameras = await availableCameras();
  CameraDescription? firstCamera;
  if (cameras.isNotEmpty) {
    firstCamera = cameras.first;
  } else {
    firstCamera = null;
  }

  final MainController controller = Get.put(MainController());
  controller.camera = firstCamera;

  await dotenv.load(fileName: 'assets/config/.env');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedToken = prefs.getString('fcm_token');
  if (storedToken == null || storedToken.isEmpty) {
    String? newToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BDhKNwXXy_46EWu4VB9JscpR2qoRj_mSqpmp_cKVSJ1g7dmU4g48YRk0i5jhjpTixK9IlA5kaTNCUwe__vP2dY4");
    if (newToken != null) {
      prefs.setString('fcm_token', newToken);
      controller.fcmToken.value = newToken;
    }
  } else {
    controller.fcmToken.value = storedToken;
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    controller.receiveNotification.value = true;
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const App());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final MainController controller = Get.put(MainController());
  controller.receiveNotification.value = true;
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
        GetPage(name: '/landing', page: () => const LandingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/officer', page: () => const OfficerScreen()),
      ],
    );
  }
}
