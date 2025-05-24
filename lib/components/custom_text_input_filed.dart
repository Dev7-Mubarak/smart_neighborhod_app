import 'package:flutter/material.dart';

import 'constants/app_size.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final double width;
  final double height;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function()? onTap;
  final bool readOnly;
  final IconData? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.textAlign = TextAlign.right,
    this.width = 290,
    this.height = 39,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        textAlign: textAlign,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onTap: onTap,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintText: hintText,
          suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
