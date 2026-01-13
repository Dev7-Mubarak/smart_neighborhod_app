class ProfileModel {
  late String id;
  late String identifier;
  late String token;
  late String role;

  ProfileModel({
    required this.id,
    required this.identifier,
    required this.token,
    required this.role,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'identifier': identifier, 'role': role, 'token': token};
  }
}
