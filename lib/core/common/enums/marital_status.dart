enum MaritalStatus { single, married }

extension MaritalStatusExtension on MaritalStatus {
  String get arabicName {
    switch (this) {
      case MaritalStatus.single:
        return 'أعزب';
      case MaritalStatus.married:
        return 'متزوج';
      // case MaritalStatus.divorced:
      //   return 'مطلق';
      // case MaritalStatus.widowed:
      //   return 'أرمل';
    }
  }
}
