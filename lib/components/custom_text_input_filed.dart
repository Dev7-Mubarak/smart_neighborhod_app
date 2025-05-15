import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final double width;
  final double height;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    this.hintText = 'Enter text',
    this.controller,
    this.textAlign = TextAlign.right,
    this.width = 290,
    this.height = 39,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.5),
        border: Border.all(
          color: const Color(0xFFE4E4E4),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        textAlign: textAlign,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          isCollapsed: true,
        ),
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
