import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'constants/app_size.dart';

class SearchableTextFormField extends StatelessWidget {
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
  final void Function(String)? onChanged;
  final bool isBordred;

  const SearchableTextFormField({
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
    this.isBordred = true,
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
      cursorColor: AppColor.primaryColor,
      decoration: InputDecoration(
        fillColor: bachgroundColor,
        filled: true,
        isDense: true,
        contentPadding:
            const EdgeInsets.only(left: 4, right: 0, top: 12, bottom: 12),
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
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
          borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}
