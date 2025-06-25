class UserData {
  late String id;
  late String email;

  UserData({required this.id, required this.email});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    email = json['email'] ?? '';
  }
}
