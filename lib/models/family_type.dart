class FamilyType {
  late int id;
  late String name;

  FamilyType.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
  }
}
