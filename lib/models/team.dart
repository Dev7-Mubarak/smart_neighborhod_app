import 'package:smart_negborhood_app/models/project_catgory.dart';
import 'package:smart_negborhood_app/models/team_member.dart';

import 'enums/project_priority.dart';
import 'enums/project_status.dart';

class Team {
  late int id;
  late String name;
  late List<TeamMember> teamMembers;

  Team({required this.id, required this.name, required this.teamMembers});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json["id"] as int, // يجب أن تكون int ولا تكون null
      name: json["name"] as String, // يجب أن تكون String ولا تكون null
      teamMembers: (json["members"] as List<dynamic>)
          .map(
            (e) => TeamMember.fromJson(e as Map<String, dynamic>),
          ) 
          .toList(),
    );
  }
}


