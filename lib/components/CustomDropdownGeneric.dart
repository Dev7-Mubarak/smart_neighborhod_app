import 'package:flutter/material.dart';
import 'constants/app_size.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? selectedValue;
  final String? text;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String Function(T)? itemLabel;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.validator,
    required this.itemLabel, // Used to convert item to label
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<T>(
          value: selectedValue,
          isExpanded: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
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
          alignment: Alignment.centerRight,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: text != null
                ? Text(
                    text!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : null,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black87,
            size: 24,
          ),
          items: items.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                itemLabel!(value),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
}
