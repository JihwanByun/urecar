import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  // 미리 설정된 값
  final Color color;
  final double size;
  final Duration duration;

  const Spinner({
    super.key,
    this.color = Colors.greenAccent, // 기본 색상
    this.size = 50.0, // 기본 크기
    this.duration = const Duration(milliseconds: 1200), // 기본 지속 시간
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRotatingCircle(
        color: color,
        size: size,
        duration: duration,
      ),
    );
  }
}
