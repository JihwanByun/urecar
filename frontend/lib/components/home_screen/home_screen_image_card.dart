import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenImageCard extends StatelessWidget {
  final String imageLink;
  final String title;
  final Widget screen;
  const HomeScreenImageCard({
    super.key,
    required this.imageLink,
    required this.screen,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          child: Stack(children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                imageLink,
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ),
            )
          ]),
          onTap: () => Get.to(screen),
        ),
      ),
    );
  }
}
