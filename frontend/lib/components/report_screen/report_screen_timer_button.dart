import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/components/common/button.dart';

class ReportScreenTimerButton extends StatefulWidget {
  final VoidCallback onButtonPressed;
  final int seconds;
  final Function(bool) onEnabledChanged;
  const ReportScreenTimerButton(
      {super.key,
      required this.onButtonPressed,
      required this.seconds,
      required this.onEnabledChanged});

  @override
  State<ReportScreenTimerButton> createState() =>
      _ReportScreenTimerButtonState();
}

class _ReportScreenTimerButtonState extends State<ReportScreenTimerButton> {
  bool _isButtonEnabled = false;
  double _progressValue = 0.0;
  late Timer _timer = Timer(const Duration(seconds: 0), () {});

  @override
  void initState() {
    super.initState();
    if (widget.seconds > 60) {
      setState(() {
        _progressValue = 2.0;
        _isButtonEnabled = true;
        widget.onEnabledChanged(true);
      });
    } else {
      _startLoading();
    }
  }

  void _startLoading() {
    const oneSec = Duration(seconds: 1);
    int counter = 0;
    if (widget.seconds < 60) {
      _timer = Timer.periodic(oneSec, (Timer timer) {
        if (counter < (60 - widget.seconds)) {
          setState(() {
            _progressValue = counter / (60 - widget.seconds);
          });
          counter++;
        } else {
          setState(() {
            _progressValue = 1.0;
            _isButtonEnabled = true;
          });
          widget.onEnabledChanged(true);
          _timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _progressValue != 2.0
              ? LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 8,
                )
              : const SizedBox(),
          const SizedBox(height: 16),
          Button(
              text: "2차 사진 촬영하기",
              onPressed:
                  _isButtonEnabled == true ? widget.onButtonPressed : null,
              horizontal: 95,
              vertical: 10,
              fontSize: 16)
        ],
      ),
    );
  }
}
