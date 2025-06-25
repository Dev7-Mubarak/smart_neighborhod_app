import 'package:flutter/material.dart';

class DateTimeHelper {
  static Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("ar", "SA"), // ضبط التقويم على العربية
    );
    
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }

   static Future<void> selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale("ar", "SA"), // ضبط اللغة على العربية
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = "${picked.hour}:${picked.minute}";
    }
  }
}
