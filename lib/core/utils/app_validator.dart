class AppValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'قم بإدخال عنوان البريد الإلكتروني';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'الرجاء إدخال بريد إلكتروني صالح';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل';
    }
    return null;
  }

 static String? validateDropdown<T>(T? value) {
    if (value == null) {
      return "الرجاء قم بالإختيار من القائمه";
    }
    return null;
  }

  static String? validateEmptyField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الرجاء قم بملء الحقل';
    }
    return null;
  }

  static String? validatebudget(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الميزانية مطلوبة';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'الرجاء إدخال أرقام فقط في حقل الميزانية';
    }
    return null;
  }
}
