import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/app_color.dart';
import 'package:smart_neighborhod_app/components/constants/app_size.dart';

class DefaultTextFormFiled extends StatelessWidget {
  DefaultTextFormFiled({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.isPassword,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.prefixIcon,
    this.onPrefixIconPressed,
    Color? bordercolor,
    Color? fillcolor,
    this.onTap, // جعلها اختيارية
    this.readOnly = false, // قيمة افتراضية
    this.maxLines = 1, // عدد الأسطر الافتراضي
  })  : bordercolor = bordercolor ?? AppColor.white,
        fillcolor = fillcolor ?? AppColor.gray;
  // super(key: key);

  final String hintText;
  final Color bordercolor;
  final Color fillcolor;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final IconData? suffixIcon;
  final void Function()? onTap; // لم يعد إلزاميًا تمريرها
  final bool readOnly; // تم إعطاء قيمة افتراضية false
  final IconData? prefixIcon;
  final bool isPassword;
  final void Function()? onPrefixIconPressed;
  final int? maxLines; // عدد الأسطر

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        readOnly: readOnly, // يتم استخدام القيمة الافتراضية عند عدم التمرير
        onTap: onTap, // إذا لم يتم تمريرها، لن تؤثر على الحقل
        obscureText: isPassword,
        maxLines: maxLines, // عدد الأسطر

        decoration: InputDecoration(
          fillColor: fillcolor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: BorderSide(width: 3, color: bordercolor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.defaultBorderRadious),
            borderSide: BorderSide(width: 3, color: bordercolor),
          ),
          suffixIcon: Icon(suffixIcon),
          prefixIcon: prefixIcon != null
              ? IconButton(
                  icon: Icon(prefixIcon), onPressed: onPrefixIconPressed)
              : null,
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        ),
      ),
    );
  }
}
