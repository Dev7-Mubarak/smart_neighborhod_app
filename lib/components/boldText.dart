import 'package:flutter/material.dart';

class boldtext extends StatelessWidget {
  const boldtext({
    super.key,
    required this.text,
    required this.fontsize,
    required this.fontcolor,
    required this.boldSize,
    this.textAlign = TextAlign.right,
  });
  final String text;
  final TextAlign textAlign;
  final double fontsize;
  final double boldSize;
  final Color fontcolor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: FontWeight.bold,
        color: fontcolor,
        shadows: [
          Shadow(
            offset: Offset(boldSize, boldSize), // تغيير الإزاحة حسب الحاجة
            blurRadius: 1.5,
            color: fontcolor, // لون الحدود
          ),
          Shadow(
            offset: Offset(-boldSize, -boldSize),
            blurRadius: 1.5,
            color: fontcolor,
          ),
          Shadow(
            offset: Offset(boldSize, -boldSize),
            blurRadius: 1.5,
            color: fontcolor,
          ),
          Shadow(
            offset: Offset(-boldSize, boldSize),
            blurRadius: 1.5,
            color: fontcolor,
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
