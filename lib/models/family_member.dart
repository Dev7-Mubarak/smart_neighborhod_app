import 'package:smart_negborhood_app/models/Person.dart';

class FamilyMember {
  late String memberTypeName;
  late List<Person>? people;

  FamilyMember({required this.memberTypeName, required this.people});

  FamilyMember.fromJson(Map<String, dynamic> json) {
    memberTypeName = json["memberTypeName"] ?? "test";
    var people = json["people"] as List;
    people = people.map((e) => Person.fromJson(json)).toList();
  }
}
