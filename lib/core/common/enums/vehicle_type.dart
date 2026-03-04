enum VehicleType {
  Unknown,
  Motorcycle,
  Car,
  Pickup,
  Truck,
  Bus,
  Tractor,
  Bicycle;

  String get arabicName {
    switch (this) {
      case VehicleType.Unknown:
        return 'غير محدد';
      case VehicleType.Motorcycle:
        return 'دراجة نارية';
      case VehicleType.Car:
        return 'سيارة';
      case VehicleType.Pickup:
        return 'بيك أب';
      case VehicleType.Truck:
        return 'شاحنة';
      case VehicleType.Bus:
        return 'حافلة';
      case VehicleType.Tractor:
        return 'جرار';
      case VehicleType.Bicycle:
        return 'دراجة هوائية';
    }
  }
}
