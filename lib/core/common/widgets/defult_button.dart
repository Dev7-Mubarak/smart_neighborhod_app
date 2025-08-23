import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.color,
    required this.onPressed,
   required this.fontsize,
  });

  final String text;
  final Color backgroundColor;
  final Color color;
  final double fontsize;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 353,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: fontsize,
              fontWeight: FontWeight.bold,
              // fontFamily: 'Tajawal',
              height: 31 / 25,
            ),
          ),
        ),
      ),
    );
  }
}
