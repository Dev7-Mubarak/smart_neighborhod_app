class User {
  final String password;
  final String email;

  User({required this.password, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      password: json['password'],
      email: json['email'],
    );
  }
}
