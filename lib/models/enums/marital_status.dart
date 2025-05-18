enum MaritalStatus {
  single,
  married,
  divorced,
  widowed,
}

extension MaritalStatusExtension on MaritalStatus {
  String get displayName {
    switch (this) {
      case MaritalStatus.single:
        return 'أعزب';
      case MaritalStatus.married:
        return 'متزوج';
      case MaritalStatus.divorced:
        return 'مطلق';
      case MaritalStatus.widowed:
        return 'أرمل';
    }
  }
}
