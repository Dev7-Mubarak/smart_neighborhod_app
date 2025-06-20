import 'package:flutter/material.dart';
import 'constants/app_size.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function()? onTap;
  final bool readOnly;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Color bachgroundColor;
  final int? maxLines; // تمت إضافته لدعم الأسطر المتعددة
  final int? minLines; // تمت إضافته لدعم الأسطر المتعددة
  final void Function(String)? onChanged;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.textAlign = TextAlign.right,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.bachgroundColor = Colors.white,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1, // الافتراضي هو 1 لإدخال سطر واحد
    this.minLines, // لا يوجد افتراضي، يسمح بأن يكون فارغًا لإدخال سطر واحد
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      readOnly: readOnly,
      controller: controller,
      textAlign: textAlign,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      maxLines: maxLines, // تطبيق maxLines
      minLines: minLines, // تطبيق minLines
      decoration: InputDecoration(
        fillColor: bachgroundColor,
        filled: true,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: Colors.black,
              ),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(
                suffixIcon,
                color: Colors.black,
              ),
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
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}
