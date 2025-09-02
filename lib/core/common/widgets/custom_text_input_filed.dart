import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/core/constants/app_size.dart';

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
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final void Function()? onsuffixIconPressed;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;
final void Function(String)? onSubmitted;

  const CustomTextFormField({
        this.onsuffixIconPressed,
  this.onSubmitted,
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
    this.maxLines = 1,
    this.minLines,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 14),
        prefixIcon: prefixIcon == null
            ? null
            :Icon(prefixIcon,color: Colors.black),   
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(icon:Icon(suffixIcon,color: Colors.black),onPressed: onsuffixIconPressed),
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
      onFieldSubmitted:onSubmitted,
    );
  }
}
