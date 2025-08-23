class TeamRole {
  late int id;
  late String name;

  TeamRole({required this.id, required this.name});

  factory TeamRole.fromJson(Map<String, dynamic> json) {
    return TeamRole(
      id: json["id"] as int, 
      name: json["name"] as String,
    );
  }
}


