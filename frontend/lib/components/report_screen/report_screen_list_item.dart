import 'package:flutter/material.dart';

class ReportScreenListItem extends StatelessWidget {
  final String title;
  final String content;
  final Color? fontColor;
  const ReportScreenListItem({
    super.key,
    required this.title,
    required this.content,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: fontColor ?? Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
