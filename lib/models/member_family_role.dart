class MemberFamilyRole {
  final int id;
  final String roleName;

  MemberFamilyRole({required this.id, required this.roleName});

  factory MemberFamilyRole.fromJson(Map<String, dynamic> json) {
    return MemberFamilyRole(
      id: json['id'] ?? 0,
      roleName: json['roleName'] ?? '',
    );
  }
}
