class Person {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String job;
  final String? email;
  final DateTime dateOfBirth;
  final int gender;
  final String? image;
  final String bloodType;
  final String identityNumber;
  final String? typeOfIdentity;
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
      id: json['person']['id'] as int,
      fullName: json['person']['fullName'],
      phoneNumber: json['person']['phoneNumber'],
      job: json['person']['job'],
      email: json['person']['email'],
      dateOfBirth: DateTime.parse(json['person']['dateOfBirth']),
      gender: json['person']['gender'] as int,
      image: json['person']['image'],
      bloodType: json['person']['bloodType'],
      identityNumber: json['person']['identityNumber'],
      typeOfIdentity: json['person']['typeOfIdentity'],
      status: json['person']['status'],
      memberTypeName: json['person']['memberTypeName'],
    );
  }

  factory Person.fromJsonFor(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      job: json['job'],
      email: json['email'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'] as int,
      image: json['image'],
      bloodType: json['bloodType'],
      identityNumber: json['identityNumber'],
      typeOfIdentity: json['typeOfIdentity'],
      status: json['status'],
      memberTypeName: json['memberTypeName'],
    );
  }
}
