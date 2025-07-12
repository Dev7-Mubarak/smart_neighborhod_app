class FamilyMemberDetailsModel {
  final int id;
  final String fullName;
  final String gender;
  final String birthDate;
  final String documentType;
  final String documentNumber;
  final String phoneNumber;
  final String contactMethod;
  final String email;
  final String status;
  final String job;
  final String bloodType;
  final String maritalStatus;
  final String familyRole;
  final String notes;
  final List<ServiceUsage> usages;

  FamilyMemberDetailsModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.birthDate,
    required this.documentType,
    required this.documentNumber,
    required this.phoneNumber,
    required this.contactMethod,
    required this.email,
    required this.status,
    required this.job,
    required this.bloodType,
    required this.maritalStatus,
    required this.familyRole,
    required this.notes,
    required this.usages,
  });

  factory FamilyMemberDetailsModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDetailsModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      documentType: json['documentType'] as String? ?? '',
      documentNumber: json['documentNumber'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      contactMethod: json['contactMethod'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? '',
      job: json['job'] as String? ?? '',
      bloodType: json['bloodType'] as String? ?? '',
      maritalStatus: json['maritalStatus'] as String? ?? '',
      familyRole: json['familyRole'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      usages: (json['usages'] as List<dynamic>?)
          ?.map((usage) => ServiceUsage.fromJson(usage as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class ServiceUsage {
  final int id;
  final String type;
  final String name;
  final String date;
  final String status;

  ServiceUsage({
    required this.id,
    required this.type,
    required this.name,
    required this.date,
    required this.status,
  });

  factory ServiceUsage.fromJson(Map<String, dynamic> json) {
    return ServiceUsage(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}