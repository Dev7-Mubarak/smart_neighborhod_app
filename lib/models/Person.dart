class Person {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String job;
  final String email;
  final DateTime dateOfBirth;
  final int gender;
  final String? image;
  final String bloodType;
  final String identityNumber;
  final String typeOfIdentity;
  final String status;
  final String? memberTypeName;

  Person({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.job,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodType,
    required this.identityNumber,
    required this.typeOfIdentity,
    required this.status,
    this.memberTypeName,
    this.image,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      job: json['job'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as int,
      image: json['image'] as String?,
      bloodType: json['bloodType'] as String,
      identityNumber: json['identityNumber'] as String,
      typeOfIdentity: json['typeOfIdentity'] as String,
      status: json['status'] as String,
      memberTypeName: json['memberTypeName'] as String,
    );
  }
}
