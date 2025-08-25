class UserData {
  late String id;
  late String email;
  late String token;
  

  UserData({required this.id, required this.email,required this.token});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    token = json['token'] ?? '';
  }
}
