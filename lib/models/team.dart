import 'package:equatable/equatable.dart';
import 'package:smart_negborhood_app/models/team_member.dart';


class Team extends Equatable{
  late int id;
  late String name;
  late List<TeamMember> teamMembers;

  Team({this.id = 0, this.name= '',this.teamMembers=const []});

  factory Team.fromJson(Map<String, dynamic> json) {
    final membersData = json["teamMembers"] as List<dynamic>?;
    return Team(
      id: json["id"] as int? ?? 0,
      name: json["name"] as String? ?? "",
      teamMembers:
       membersData?.map(
        (e) => TeamMember.fromJson(e as Map<String, dynamic>),
      ).toList()??const [], 
    );
    
  }
  @override
  List<Object?> get props => [id, name, teamMembers];
}
