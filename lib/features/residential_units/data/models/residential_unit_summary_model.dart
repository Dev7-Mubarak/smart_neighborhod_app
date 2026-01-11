class ResidentialUnitSummaryModel {
  late int unitId;
  late String unitName;
  late int blocksCount;

  ResidentialUnitSummaryModel.fromJson(Map<String, dynamic> json) {
    unitId = json['unitId'];
    unitName = json['unitName'] ?? '';
    blocksCount = json['blocksCount'] ?? 0;
  }
}
