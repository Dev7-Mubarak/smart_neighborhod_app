class Block {
  late int id;
  late String name;
  late int personId;
  late String userName;
  late String fullName;

  Block.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
    // managerId = json["managerId"] ?? "";
    personId = json["personId"] ?? "";
    userName = json["userName"] ?? "";
    fullName = json["fullName"] ?? "";
  }
}
