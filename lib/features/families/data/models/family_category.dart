class FamilyCategory {
  late int id;
  late String name;

  FamilyCategory({this.id = 0, this.name = ""});

  FamilyCategory.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
  }
}
