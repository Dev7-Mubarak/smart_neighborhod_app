import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';

class Team {
  late int id;
  late String name;
  late List<TeamMember> teamMembers;

  Team({required this.id, required this.name, required this.teamMembers});

  factory Team.fromJson(Map<String, dynamic> json) {
    final membersData = json["teamMembers"] as List<dynamic>?;
    return Team(
      id: json["id"] as int,
      name: json["name"] as String,
      teamMembers:
          membersData
              ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
    //  (json["members"] as List<dynamic>)
    //           .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
    //           .toList(),
    //     );
  }
}
