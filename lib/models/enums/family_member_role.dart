enum FamilyMemberRole {
  father,      // الأب
  mother,      // الأم
  son,         // الابن
  daughter,    // الابنة
  grandfather, // الجد
  grandmother, // الجدة
  brother,     // الأخ
  sister,      // الأخت
  uncle,       // العم
  aunt,        // العمة
  cousin,      // ابن العم/الخال
  other,       // أخرى
}

extension FamilyMemberRoleExtension on FamilyMemberRole {
  String get displayName {
    switch (this) {
      case FamilyMemberRole.father:
        return 'الأب';
      case FamilyMemberRole.mother:
        return 'الأم';
      case FamilyMemberRole.son:
        return 'الابن';
      case FamilyMemberRole.daughter:
        return 'الابنة';
      case FamilyMemberRole.grandfather:
        return 'الجد';
      case FamilyMemberRole.grandmother:
        return 'الجدة';
      case FamilyMemberRole.brother:
        return 'الأخ';
      case FamilyMemberRole.sister:
        return 'الأخت';
      case FamilyMemberRole.uncle:
        return 'العم';
      case FamilyMemberRole.aunt:
        return 'العمة';
      case FamilyMemberRole.cousin:
        return 'ابن العم/الخال';
      case FamilyMemberRole.other:
        return 'أخرى';
    }
  }

  static List<String> getDisplayNames() {
    return FamilyMemberRole.values.map((role) => role.displayName).toList();
  }

  static FamilyMemberRole fromDisplayName(String displayName) {
    return FamilyMemberRole.values.firstWhere(
      (role) => role.displayName == displayName,
      orElse: () => FamilyMemberRole.other,
    );
  }
}