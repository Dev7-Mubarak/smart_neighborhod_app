enum Gender { male, female }

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
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
    return Gender.values.map((e) => e.displayName).toList();
  }
}
