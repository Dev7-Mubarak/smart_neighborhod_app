import 'package:equatable/equatable.dart';

class GovernmentInstitutionContact extends Equatable {
  final int id;
  final int governmentInstitutionId;
  final String name;
  final String job;
  final String phone;

  const GovernmentInstitutionContact({
    this.id = 0,
    this.governmentInstitutionId = 0,
    this.name = '',
    this.job = '',
    this.phone = '',
  });

  factory GovernmentInstitutionContact.fromJson(Map<String, dynamic> json) {
    return GovernmentInstitutionContact(
      id: json['id'] as int? ?? 0,
      governmentInstitutionId: json['governmentInstitutionId'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      job: json['job'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, governmentInstitutionId, name, job, phone];
}
