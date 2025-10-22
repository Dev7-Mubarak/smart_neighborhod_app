enum OccupationStatus {
  employee,
  student,
  unemployed,
  // Add more if needed
}

extension OccupationStatusExtension on OccupationStatus {
  String get arabicName {
    switch (this) {
      case OccupationStatus.employee:
        return 'يعمل';
      case OccupationStatus.student:
        return 'طالب';
      case OccupationStatus.unemployed:
        return 'عاطل عن العمل';
    }
  }
}
