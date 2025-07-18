enum IdentityType { identityCard, passport, birthCertificate }

extension IdentityTypeExtension on IdentityType {
  String get arabicName {
    switch (this) {
      case IdentityType.identityCard:
        return 'بطاقة شخصية';
      case IdentityType.passport:
        return 'جواز سفر';
      case IdentityType.birthCertificate:
        return 'شهادة ميلاد';
    }
  }
}
