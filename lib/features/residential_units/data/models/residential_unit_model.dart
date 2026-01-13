class ResidentialUnitModel {
  late int id;
  late String name;
  late int blocksCount;
  late String unitManagerId;
  late String unitManagerName;

  ResidentialUnitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    blocksCount = json['blocksCount'] ?? 0;
    unitManagerId = json['unitManagerId'] ?? '';
    unitManagerName = json['unitManagerName'] ?? '';
  }
}
