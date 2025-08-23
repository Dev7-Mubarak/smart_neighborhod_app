import 'package:flutter/material.dart';
import '../generated/l10n.dart';

enum Gender { male, female }

extension GenderExtension on Gender {
  String get arabicName {
    switch (this) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
    }
  }

  String localizedName(BuildContext context) {
    switch (this) {
      case Gender.male:
        return S.of(context).male;
      case Gender.female:
        return S.of(context).female;
    }
  }

  static Gender fromDisplayName(String name) {
    switch (name) {
      case 'ذكر':
        return Gender.male;
      case 'أنثى':
        return Gender.female;
      default:
        throw ArgumentError('Invalid gender display name');
    }
  }

  static List<String> getDisplayNames() {
    return Gender.values.map((e) => e.arabicName).toList();
  }

  static List<String> getLocalizedDisplayNames(BuildContext context) {
    return Gender.values.map((e) => e.localizedName(context)).toList();
  }
}
