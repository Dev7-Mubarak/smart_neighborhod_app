class LoginModel {
  late int statusCode;
  late bool succeeded;
  late String message;
  late UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    succeeded = json['succeeded'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData {
  late String id;
  late String email;

  UserData({required this.id, required this.email});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }
}
