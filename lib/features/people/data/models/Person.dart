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
      job: json['job'] as String? ?? "",
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

  static BloodType _bloodTypeFromString(String value) {
    return BloodType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => BloodType.values.first,
    );
  }

  static OccupationStatus _occupationStatusFromString(String value) {
    return OccupationStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => OccupationStatus.values.first,
    );
  }

  static MaritalStatus _maritalStatusFromString(String value) {
    return MaritalStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => MaritalStatus.values.first,
    );
  }

  static VehicleType? _vehicleTypeFromString(String? value) {
    if (value == null) return null;
    return VehicleType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => VehicleType.Unknown,
    );
  }

  static ResidencyStatus? _residencyStatusFromString(String? value) {
    if (value == null) return null;
    return ResidencyStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ResidencyStatus.Resident,
    );
  }
}
