import 'residential_unit_summary_model.dart';

class ResidentialUnitDashboardModel {
  late int totalUnits;
  late int totalBlocks;
  late List<ResidentialUnitSummaryModel> units;

  ResidentialUnitDashboardModel.fromJson(Map<String, dynamic> json) {
    totalUnits = json['totalUnits'] ?? 0;
    totalBlocks = json['totalBlocks'] ?? 0;
    if (json['units'] != null) {
      units = (json['units'] as List<dynamic>)
          .map((e) => ResidentialUnitSummaryModel.fromJson(e))
          .toList();
    } else {
      units = [];
    }
  }
}
