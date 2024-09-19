import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/screens/check_image_screen.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() {
    final MainController controller = Get.find<MainController>();
    if (controller.camera != null) {
      _controller = CameraController(
        controller.camera!,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller!.initialize();
    } else {
      print("카메라가 없습니다.");
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // 카메라 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBar(
          onNotificationPressed: () {
            controller.showNotification;
          },
        ),
      ),
      body: _controller == null
          ? const Center(child: Text('카메라를 사용할 수 없습니다.'))
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: _controller != null
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: SizedBox(
                height: 70,
                child: FittedBox(
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller!.takePicture();
                        if (!mounted) return;
                        await Get.to(
                            () => CheckImageScreen(imagePath: image.path));
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) async {
          controller.changePage(index);
        },
      ),
    );
  }
}
