import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final MainController controller = Get.put(MainController());
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (controller.camera != null) {
      _controller = CameraController(
        controller.camera!,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller.initialize();
    } else {
      print("카메라가 없습니다.");
    }
  }

  @override
  void dispose() {
    // 사용이 끝나면 카메라 컨트롤러를 해제합니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.camera == null) {
      return const Center(
        child: Text('카메라를 사용할 수 없습니다.'),
      );
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 카메라 프리뷰가 준비되었으면 이를 화면에 표시합니다.
          return CameraPreview(_controller);
        } else {
          // 카메라가 준비 중이라면 로딩 인디케이터를 표시합니다.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
