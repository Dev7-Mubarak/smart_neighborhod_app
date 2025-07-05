class TeamMember {
  late int teamMemberId;
  late int personId;
  late DateTime? dateOfJoin;
  late int teamRoleId;
  late int teamId;
  late int teamName;
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
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
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
}