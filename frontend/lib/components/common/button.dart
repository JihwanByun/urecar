import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double horizontal;
  final double vertical;
  final double fontSize;
  final IconData? icon;
  final double? iconSize;
  final double? radius;
  final Color? backgroundColor;
  final Color? contentColor;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    required this.horizontal,
    required this.vertical,
    required this.fontSize,
    this.icon,
    this.iconSize,
    this.radius,
    this.backgroundColor,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 10))),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: Column(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: iconSize ?? 15,
                    color: contentColor ?? Colors.white,
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              style: TextStyle(
                color: contentColor ?? Colors.white,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
