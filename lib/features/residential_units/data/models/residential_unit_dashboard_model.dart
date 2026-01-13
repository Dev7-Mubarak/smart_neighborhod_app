import 'residential_unit_model.dart';

class ResidentialUnitDashboardModel {
  late int totalUnits;
  late int totalBlocks;
  late List<ResidentialUnitModel> units;

  ResidentialUnitDashboardModel.fromJson(Map<String, dynamic> json) {
    totalUnits = json['totalUnits'] ?? 0;
    totalBlocks = json['totalBlocks'] ?? 0;
    if (json['units'] != null) {
      units = (json['units'] as List<dynamic>)
          .map((e) => ResidentialUnitModel.fromJson(e))
          .toList();
    } else {
      units = [];
    }
  }
}
