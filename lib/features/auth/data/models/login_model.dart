class ProfileModel {
  late String id;
  late String email;
  late String token;
  late String role;

  ProfileModel({
    required this.id,
    required this.email,
    required this.token,
    required this.role,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'role': role, 'token': token};
  }
}
