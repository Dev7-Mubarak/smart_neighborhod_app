class Block {
  late int id;
  late String name;
  late String managerId;
  late int personId;
  late String email;
  late String fullName;

  Block.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
    managerId = json["managerId"] ?? "";
    personId = json["personId"] ?? "";
    email = json["email"] ?? "";
    fullName = json["fullName"] ?? "";
  }
}
