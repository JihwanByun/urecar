import 'package:flutter/material.dart';

class SettingScreenItem extends StatelessWidget {
  final String title;
  const SettingScreenItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: 40,
          )
        ],
      ),
    );
  }
}
