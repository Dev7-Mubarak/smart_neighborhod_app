import 'package:smart_negborhood_app/features/people/data/models/Person.dart';
import 'package:smart_negborhood_app/features/families/data/models/member_family_role.dart';

class FamilyMember2 {
  late int familyMemberId;
  late MemberFamilyRole role;
  late Person person;

  FamilyMember2({
    required this.familyMemberId,
    required this.person,
    required this.role,
  });

  factory FamilyMember2.fromJson(Map<String, dynamic> json) {
    return FamilyMember2(
      familyMemberId: json["familyMemberId"],
      person: Person.fromJson(json["person"] ?? {}),
      role: MemberFamilyRole.fromJson(json["role"] ?? {}),
    );
  }
}
