class FamilyModel {
  late int id;
  late String name;
  late String location;
  late int familyCategoryId;
  late String familyCategoryName;

  FamilyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    location = json['location'] ?? '';
    familyCategoryId = json['familyCategoryId'] ?? 0;
    familyCategoryName = json['familyCategoryName'] ?? '';
  }
}
