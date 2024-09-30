import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/components/common/bottom_navigation.dart';
import 'package:frontend/components/common/spinner.dart';
import 'package:frontend/components/common/top_bar.dart';
import 'package:frontend/screens/check_image_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  late double longitude;
  late double latitude;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    checkPermission();
  }

  void checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }
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

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    longitude = position.longitude;
    latitude = position.latitude;
  }

  @override
  void dispose() {
    _controller?.dispose();
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
                  return const Spinner();
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
                        Get.dialog(
                          const Spinner(),
                          barrierDismissible: false,
                        );

                        await _initializeControllerFuture;
                        final image = await _controller!.takePicture();

                        await getLocation();

                        Get.back();

                        if (!mounted) return;
                        Get.to(() => CheckImageScreen(
                              imagePath: image.path,
                              longitude: longitude,
                              latitude: latitude,
                            ));
                      } catch (e) {
                        print(e);
                        Get.back();
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
