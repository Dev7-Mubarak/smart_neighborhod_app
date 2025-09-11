import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';

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
        fontSize: AppSize.textSizeOfLable,
        color: color,
        fontWeight: fontWeight ?? FontWeight.bold,
      ),
    );
  }
}
