enum PersonType {
  Citizen,
  BlockManager,
  UnitManager,
  Admin;

  String get arabicName {
    switch (this) {
      case PersonType.Citizen:
        return 'مواطن';
      case PersonType.BlockManager:
        return 'مدير مجمع';
      case PersonType.UnitManager:
        return 'مدير وحدة';
      case PersonType.Admin:
        return 'مدير';
    }
  }
}
