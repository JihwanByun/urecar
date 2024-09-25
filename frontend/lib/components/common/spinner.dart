import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;
  final Duration delay;

  const Spinner(
      {super.key,
      this.color = Colors.greenAccent,
      this.size = 50.0,
      this.duration = const Duration(milliseconds: 1200),
      this.delay = const Duration(milliseconds: 50)});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeInOut(
        color: color,
        size: size,
        duration: duration,
        delay: delay,
      ),
    );
  }
}
