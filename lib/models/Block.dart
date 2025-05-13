class Block {
  late int id;
  late String name;
  late String managerId;
  late String managerName;

  Block.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
    managerId = json["managerId"] ?? "";
    managerName = json["managerName"] ?? "";
  }
}
