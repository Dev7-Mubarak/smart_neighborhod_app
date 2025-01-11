import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/constants/app_size.dart';

class DefaultTextFormFiled extends StatelessWidget {
  const DefaultTextFormFiled({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.isPassword,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.prefixIcon,
    this.onPrefixIconPressed,
  });

  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final IconData suffixIcon;
  final IconData? prefixIcon;
  final bool isPassword;
  final void Function()? onPrefixIconPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 347,
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        obscureText: isPassword,
        decoration: InputDecoration(
          fillColor: AppColor.gray,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(width: 1, color: AppColor.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: const BorderSide(width: 1, color: AppColor.white),
          ),
          suffixIcon: Icon(suffixIcon),
          prefixIcon: prefixIcon != null
              ? IconButton(
                  icon: Icon(prefixIcon), onPressed: onPrefixIconPressed)
              : null,
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }
}
