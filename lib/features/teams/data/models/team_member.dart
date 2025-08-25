import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  late int teamMemberId;
  late int personId;
  late DateTime? dateOfJoin;
  late int teamRoleId;
  late int teamId;
  late String teamName;
  late String teamRoleName;
  late String personName;

  TeamMember({
    required this.teamMemberId,
    required this.personId,
    required this.personName,

    required this.dateOfJoin,
    required this.teamRoleId,
    required this.teamRoleName,
    required this.teamId,
    required this.teamName,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      teamName: json["teamName"] as String? ?? "",

      teamMemberId: json["teamMemberId"] as int? ?? 0,
      personId: json["personId"] as int? ?? 0,
      dateOfJoin: (json['dateOfJoin'] != null && json['dateOfJoin'] is String)
          ? DateTime.parse(json['dateOfJoin'] as String)
          : null,
      teamRoleId: json["teamRoleId"] as int? ?? 0,
      teamId: json["teamId"] as int? ?? 0,
      teamRoleName: json["teamRoleName"] as String? ?? "",
      personName: json["personName"] as String? ?? "",
    );
  }
     // تطبيق مُنشئ props الخاص بـ Equatable
  @override
  List<Object?> get props => [
        teamMemberId,
        personId,
        personName,
        teamId,
        teamName,
        teamRoleId,
        teamRoleName,
        dateOfJoin,
      ];
}
