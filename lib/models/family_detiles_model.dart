import 'package:smart_neighborhod_app/models/Person.dart';

class FamilyDetilesModel {
  late int id;
  late String name;
  late String location;
  late int familyCatgoryId;
  late String familyCatgoryName;
  late String familyNotes;
  late String housingType;
  late int familyTypeId;
  late String familyTypeName;
  late int blockId;
  late String blockName;
  late int? headOfTheFamilyId;
  late String? headOfTheFamilyName;
  late List<Person> familyMembers;

  FamilyDetilesModel({
    required this.name,
    required this.location,
    required this.familyCatgoryId,
    required this.familyTypeId,
    required this.familyNotes,
    required this.blockId,
  });

  FamilyDetilesModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
    housingType = json["housingType"] ?? "test";
    familyCatgoryId = json["familyCatgoryId"] ?? "test";
    familyTypeId = json["familyTypeId"] ?? "test";
    location = json["location"] ?? "test";
    familyNotes = json["familyNotes"] ?? "test";
    familyCatgoryName = json["familyCatgoryName"] ?? "test";
    blockName = json["blockName"] ?? "test";
    familyTypeName = json["familyTypeName"] ?? "test";
    blockId = json["blockId"] ?? 0;
    headOfTheFamilyId = json["headOfTheFamilyId"];
    headOfTheFamilyName = json["headOfTheFamilyName"];
    var _familyMembers = json["familyMembers"] as List;
    familyMembers = _familyMembers.map((e) => Person.fromJson(e)).toList();
  }
}
