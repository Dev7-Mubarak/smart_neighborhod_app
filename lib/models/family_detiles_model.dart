import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/models/assistance.dart';

class HeadOfFamily {
  late String identityNumber;
  late String fullName;
  late String phoneNumber;

  HeadOfFamily({
    required this.identityNumber,
    required this.fullName,
    required this.phoneNumber,
  });

  HeadOfFamily.fromJson(Map<String, dynamic> json) {
    identityNumber = json["identityNumber"] ?? "";
    fullName = json["fullName"] ?? "";
    phoneNumber = json["phoneNumber"] ?? "";
  }
}

class FamilyDetilesModel {
  late int id;
  late String name;
  late String location;
  late String familyNotes;
  late int familyCategoryId;
  late String familyCategoryName;
  late int familyTypeId;
  late String familyTypeName;
  late int blockId;
  late String blockName;
  HeadOfFamily? headOfFamily;
  late List<Person> familyMembers;
  late List<Assistance> assistances;

  FamilyDetilesModel({
    required this.id,
    required this.name,
    required this.location,
    required this.familyNotes,
    required this.familyCategoryId,
    required this.familyCategoryName,
    required this.familyTypeId,
    required this.familyTypeName,
    required this.blockId,
    required this.blockName,
    this.headOfFamily,
    required this.familyMembers,
    required this.assistances,
  });

  FamilyDetilesModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "";
    location = json["location"] ?? "";
    familyNotes = json["familyNotes"] ?? "";
    familyCategoryId = json["familyCategoryId"] ?? 0;
    familyCategoryName = json["familyCategoryName"] ?? "";
    familyTypeId = json["familyTypeId"] ?? 0;
    familyTypeName = json["familyTypeName"] ?? "";
    blockId = json["blockId"] ?? 0;
    blockName = json["blockName"] ?? "";
    headOfFamily = json["headOfFamily"] != null
        ? HeadOfFamily.fromJson(json["headOfFamily"])
        : null;
    familyMembers = (json["familyMembers"] as List)
        .map((e) => Person.fromJson(e["person"]))
        .toList();
    assistances = (json["assistances"] as List)
        .map((e) => Assistance.fromJson(e))
        .toList();
  }
}
