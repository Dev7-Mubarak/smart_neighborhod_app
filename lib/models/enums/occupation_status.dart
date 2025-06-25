enum OccupationStatus {
  employee,
  student,
  unemployed,
  // Add more if needed
}

extension OccupationStatusExtension on OccupationStatus {
  String get displayName {
    switch (this) {
      case OccupationStatus.employee:
        return 'موظف';
      case OccupationStatus.student:
        return 'طالب';
      case OccupationStatus.unemployed:
        return 'عاطل عن العمل';
    }
  }
}
