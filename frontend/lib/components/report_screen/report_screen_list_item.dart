import 'package:flutter/material.dart';

class ReportScreenListItem extends StatelessWidget {
  final String title;
  final dynamic content;
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content is String
              ? Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: fontColor ?? Colors.black,
                  ),
                )
              : content as Widget,
        ],
      ),
    );
  }
}
