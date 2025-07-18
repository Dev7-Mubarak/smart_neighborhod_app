import 'package:smart_negborhood_app/models/Person.dart';
import 'package:smart_negborhood_app/models/family_member_role.dart';

class FamilyMember {
  final int familyMemberId;
  final Role role;
  final Person person;

  FamilyMember({
    required this.familyMemberId,
    required this.role,
    required this.person,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      familyMemberId: json['familyMemberId'],
      role: Role.fromJson(json['role']),
      person: Person.fromJson(json['person']),
    );
  }
}
