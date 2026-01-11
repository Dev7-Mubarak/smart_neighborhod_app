class UnitBlock {
  late int id;
  late String name;
  late String blockManagerId;
  late String blockManagerName;

  UnitBlock.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    blockManagerId = json['blockManagerId'] ?? '';
    blockManagerName = json['blockManagerName'] ?? '';
  }
}
