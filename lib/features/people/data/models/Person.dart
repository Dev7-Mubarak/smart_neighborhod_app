import '../../../../core/common/enums/blood_type.dart';
import '../../../../core/common/enums/marital_status.dart';
import '../../../../core/common/enums/occupation_status.dart';
import '../../../../core/common/enums/gender.dart';
import '../../../../core/common/enums/vehicle_type.dart';
import '../../../../core/common/enums/residency_status.dart';

class Person {
  final int id;
  String? fullNameOneString;

  final String firstName;
  final String secondName;
  final String thirdName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String? phoneNumber;

  final String? image;
  final Gender? gender;

  final BloodType bloodType;
  final OccupationStatus occupationStatus;
  final MaritalStatus maritalStatus;
  final String? job;

  // National ID (بطاقة شخصية)
  final String? nationalId;

  // Vehicle info
  final VehicleType? vehicleType;
  final String? vehicleRegistrationNumber;

  // Residency status (Resident or Displaced)
  final ResidencyStatus? residencyStatus;

  // Chronic disease info
  final bool? hasChronicDiseases;
  final String? chronicDiseasesNotes;

  Person({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.thirdName,
    required this.lastName,
    required this.phoneNumber,
    this.fullNameOneString,
    this.image,
    required this.dateOfBirth,
    required this.gender,

    required this.bloodType,
    required this.occupationStatus,
    required this.maritalStatus,
    this.job,
    this.nationalId,
    this.vehicleType,
    this.vehicleRegistrationNumber,
    this.residencyStatus,
    this.hasChronicDiseases,
    this.chronicDiseasesNotes,
  });

  // Getter for full name
  String get fullName {
    return '$firstName $secondName $thirdName $lastName';
  }

  // Optional: Factory constructor to parse from JSON, if needed
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? "",
      secondName: json['secondName'] as String? ?? "",
      thirdName: json['thirdName'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
      dateOfBirth: DateTime.parse(
        json['dateOfBirth'] as String? ?? DateTime.now().toIso8601String(),
      ),
      phoneNumber: json['phoneNumber'] as String?,
      fullNameOneString: json['fullName'] as String? ?? "",
      image: json['image'],
      gender: _genderFromString(json['gender']),

      bloodType: _bloodTypeFromString(json['bloodType']),
      occupationStatus: _occupationStatusFromString(json['occupationStatus']),
      maritalStatus: _maritalStatusFromString(json['maritalStatus']),
      job: json['job'],
      nationalId: json['nationalId'] as String?,
      vehicleType: _vehicleTypeFromString(json['vehicleType']),
      vehicleRegistrationNumber: json['vehicleRegistrationNumber'] as String?,
      residencyStatus: _residencyStatusFromString(json['residencyStatus']),
      hasChronicDiseases: json['hasChronicDiseases'] as bool?,
      chronicDiseasesNotes: json['chronicDiseasesNotes'] as String?,
    );
  }

  // Helper methods to convert string to enum
  static Gender? _genderFromString(String? value) {
    if (value == null) return null;
    return Gender.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Gender.Male,
    );
  }

  static BloodType _bloodTypeFromString(dynamic value) {
    if (value == null) return BloodType.values.first;
    final str = value.toString();
    final key = str.contains('.') ? str.split('.').last : str;

    try {
      return BloodType.values.firstWhere(
        (e) => e.name.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {}

    try {
      return BloodType.values.firstWhere(
        (e) => e.arabicName == str || e.arabicName == key,
      );
    } catch (_) {}

    return BloodType.values.first;
  }

  static OccupationStatus _occupationStatusFromString(dynamic value) {
    if (value == null) return OccupationStatus.values.first;
    final str = value.toString();
    final key = str.contains('.') ? str.split('.').last : str;

    try {
      return OccupationStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {}

    try {
      return OccupationStatus.values.firstWhere(
        (e) => e.arabicName == str || e.arabicName == key,
      );
    } catch (_) {}

    return OccupationStatus.values.first;
  }

  static MaritalStatus _maritalStatusFromString(dynamic value) {
    if (value == null) return MaritalStatus.values.first;
    final str = value.toString();
    final key = str.contains('.') ? str.split('.').last : str;

    try {
      return MaritalStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {}

    try {
      return MaritalStatus.values.firstWhere(
        (e) => e.arabicName == str || e.arabicName == key,
      );
    } catch (_) {}

    return MaritalStatus.values.first;
  }

  static VehicleType? _vehicleTypeFromString(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    final key = str.contains('.') ? str.split('.').last : str;

    try {
      return VehicleType.values.firstWhere(
        (e) => e.name.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {}

    try {
      return VehicleType.values.firstWhere(
        (e) => e.arabicName == str || e.arabicName == key,
      );
    } catch (_) {}

    return VehicleType.Unknown;
  }

  static ResidencyStatus? _residencyStatusFromString(dynamic value) {
    if (value == null) return null;
    final str = value.toString();
    final key = str.contains('.') ? str.split('.').last : str;

    try {
      return ResidencyStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == key.toLowerCase(),
      );
    } catch (_) {}

    try {
      return ResidencyStatus.values.firstWhere(
        (e) => e.arabicName == str || e.arabicName == key,
      );
    } catch (_) {}

    return ResidencyStatus.Resident;
  }
}
