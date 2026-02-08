class FamilyModel {
  late int id;
  late String name;
  late String location;
  // late String familyNotes;
  late int familyCategoryId;
  late String familyCategoryName;
  // late int familyHeadId;

  FamilyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    location = json['location'] ?? '';
    // familyNotes = json['familyNotes'] ?? '';
    familyCategoryId = json['familyCategoryId'] ?? 0;
    // familyHeadId = json['familyHeadId'] ?? 0;
    familyCategoryName = json['familyCategoryName'] ?? '';
  }
}
