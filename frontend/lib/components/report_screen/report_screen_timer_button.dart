import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';

class ReportScreenTimerButton extends StatefulWidget {
  const ReportScreenTimerButton({super.key});

  @override
  State<ReportScreenTimerButton> createState() =>
      _ReportScreenTimerButtonState();
}

class _ReportScreenTimerButtonState extends State<ReportScreenTimerButton> {
  bool _isButtonEnabled = false;
  double _progressValue = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    const oneSec = Duration(seconds: 1);
    int counter = 0;

    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (counter < 60) {
        setState(() {
          _progressValue = counter / 60;
        });
        counter++;
      } else {
        setState(() {
          _progressValue = 1.0;
          _isButtonEnabled = true;
        });
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: _progressValue,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          Button(
              text: "2차 사진 촬영하기",
              onPressed: _isButtonEnabled == true ? _onButtonPressed : null,
              horizontal: 95,
              vertical: 10,
              fontSize: 16)
        ],
      ),
    );
  }

  void _onButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('버튼이 눌렸습니다!')),
    );
  }
}
