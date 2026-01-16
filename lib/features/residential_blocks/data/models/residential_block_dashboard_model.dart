import 'residential_block_model.dart';

class ResidentialBlockDashboardModel {
  late int totalBlocks;
  late int totalFamilies;
  late List<ResidentialBlockModel> blocks;

  ResidentialBlockDashboardModel.fromJson(Map<String, dynamic> json) {
    totalBlocks = json['totalBlocks'] ?? 0;
    totalFamilies = json['totalFamilies'] ?? 0;
    if (json['blocks'] != null) {
      blocks = (json['blocks'] as List<dynamic>)
          .map((e) => ResidentialBlockModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      blocks = [];
    }
  }
}
