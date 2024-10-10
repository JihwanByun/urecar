import 'package:flutter/material.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/screens/notification_screen.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Image.asset(
        'assets/images/logo.png',
        width: 110,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(children: [
            IconButton(
                iconSize: 28,
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                  controller.receiveNotification.value = false;
                }),
            Obx(() {
              return controller.receiveNotification.value
                  ? Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(
                          color: Color(0xffe32222),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ]),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }
}
