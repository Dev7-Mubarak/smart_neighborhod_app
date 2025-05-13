import 'package:smart_neighborhod_app/models/Person.dart';

class Family {
  late int id;
  late String name;
  late String location;
  late int? familyCatgoryId;
  late String familyNotes;
  late int? familyTypeId;
  late int? blockId;
  late List<Person>? familyMembers;

  Family({
    required this.name,
    required this.location,
    required this.familyCatgoryId,
    required this.familyTypeId,
    required this.familyNotes,
    required this.blockId,
  });

  Family.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? "test";
    familyCatgoryId = json["familyCatgoryId"] ?? "test";
    familyTypeId = json["familyTypeId"] ?? "test";
    location = json["location"] ?? "test";
    familyNotes = json["familyNotes"] ?? "test";
    blockId = json["blockId"] ?? 0;
    var _familyMembers = json["familyMembers"] as List;
    familyMembers = _familyMembers.map((e) => Person.fromJson(json)).toList();
  }

  // Map<String, dynamic> toJson(int? personId) {
  //   return {
  //     "name": name,
  //     "location": location,
  //     "familyCatgoryId": familyCatgoryId,
  //     "familyNotes": familyNotes,
  //     "familyTypeId": familyTypeId,
  //     "blockId": blockId,
  //     "personId": personId
  //   };
  // }
}
