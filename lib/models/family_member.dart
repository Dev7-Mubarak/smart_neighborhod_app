import 'package:smart_neighborhod_app/models/Person.dart';

class FamilyMember {
  late String memberTypeName;
  late List<Person>? people;

  FamilyMember({
    required this.memberTypeName,
    required this.people,
  });

  FamilyMember.fromJson(Map<String, dynamic> json) {
    memberTypeName = json["memberTypeName"] ?? "test";
    var _people = json["people"] as List;
    people = _people.map((e) => Person.fromJson(json)).toList();
  }
}
