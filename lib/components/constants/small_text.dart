import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SmallText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    );
  }
}
