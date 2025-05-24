import 'enums/blood_type.dart';
import 'enums/identity_type.dart';
import 'enums/marital_status.dart';
import 'enums/occupation_status.dart';

class Person {
  final int id;
  String firstName;
  String secondName;
  String thirdName;
  String lastName;
  DateTime dateOfBirth;
  String phoneNumber;
  String? email;
  String? image;
  String gender;
  bool isCall;
  bool isWhatsapp;
  BloodType bloodType;
  String identityNumber;
  IdentityType identityType;
  OccupationStatus occupationStatus;
  MaritalStatus maritalStatus;
  String? job;

  Person(
      {required this.id,
      required this.firstName,
      required this.secondName,
      required this.thirdName,
      required this.lastName,
      required this.phoneNumber,
      this.email,
      this.image,
      required this.dateOfBirth,
      required this.gender,
      required this.bloodType,
      required this.identityNumber,
      required this.identityType,
      required this.occupationStatus,
      required this.maritalStatus,
      this.job,
      required this.isCall,
      required this.isWhatsapp});

  // Getter for full name
  String get fullName {
    return '$firstName $secondName $thirdName $lastName';
  }

  // Optional: Factory constructor to parse from JSON, if needed
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      secondName: json['secondName'] as String,
      thirdName: json['thirdName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'],
      image: json['image'],
      gender: json['gender'] as String,
      bloodType: _bloodTypeFromString(json['bloodType']),
      identityNumber: json['identityNumber'] as String,
      identityType: _identityTypeFromString(json['identityType']),
      occupationStatus: _occupationStatusFromString(json['occupationStatus']),
      maritalStatus: _maritalStatusFromString(json['maritalStatus']),
      isCall: json['isCall'],
      isWhatsapp: json['isWhatsapp'],
      job: json['job'],
    );
  }

  // Helper methods to convert string to enum
  static BloodType _bloodTypeFromString(String value) {
    return BloodType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => BloodType.aPositive,
    );
  }

  static IdentityType _identityTypeFromString(String value) {
    return IdentityType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => IdentityType.identityCard,
    );
  }

  static OccupationStatus _occupationStatusFromString(String value) {
    return OccupationStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => OccupationStatus.employee,
    );
  }

  static MaritalStatus _maritalStatusFromString(String value) {
    return MaritalStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => MaritalStatus.single,
    );
  }
}
