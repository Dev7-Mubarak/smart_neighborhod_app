class ResidentialBlockModel {
  late int id;
  late String name;
  late int familiesCount;
  late String managerId;
  late String managerName;

  ResidentialBlockModel.fromJson(Map<String, dynamic> json) {
    id = json['blockId'] ?? 0;
    name = json['blockName'] ?? '';
    familiesCount = json['familiesCount'] ?? 0;
    managerId = json['managerId'] ?? '';
    managerName = json['managerName'] ?? '';
  }
}
