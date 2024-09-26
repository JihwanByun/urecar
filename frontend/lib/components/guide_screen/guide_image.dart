import 'package:flutter/material.dart';

class GuideImage extends StatelessWidget {
  final String path;
  final String title;
  final String content;
  const GuideImage(
      {super.key,
      required this.path,
      required this.title,
      required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 153,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(path),
          ),
        ),
        Card(
          margin: const EdgeInsets.only(
            top: 10,
            bottom: 25,
            right: 50,
            left: 50,
          ),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "■ $title",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(content)
              ],
            ),
          ),
        )
      ],
    );
  }
}
