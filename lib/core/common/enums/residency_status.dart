enum ResidencyStatus {
  Resident,
  Displaced;

  String get arabicName {
    switch (this) {
      case ResidencyStatus.Resident:
        return 'مقيم';
      case ResidencyStatus.Displaced:
        return 'نازح';
    }
  }
}
