
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_color.dart';

class ResendTimerWidget extends StatefulWidget {
  final VoidCallback onResend;

  const ResendTimerWidget({super.key, required this.onResend});

  @override
  State<ResendTimerWidget> createState() => _ResendTimerWidgetState();
}

class _ResendTimerWidgetState extends State<ResendTimerWidget> {
  Timer? _timer;
  int _start = 60;
  bool _isResendButtonActive = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _isResendButtonActive = false;
      _start = 60;
    });

    const oneSec = Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendButtonActive = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isResendButtonActive
        ? TextButton(
            onPressed: () {
              widget.onResend();
              startTimer();
            },
            child: const Text(
              "إعادة إرسال الكود",
              style: TextStyle(
                fontSize: 15,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Text(
            "إعادة إرسال الكود في 00:${_start.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
