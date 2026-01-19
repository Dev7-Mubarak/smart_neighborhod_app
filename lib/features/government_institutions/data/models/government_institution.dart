import 'package:equatable/equatable.dart';
import 'government_institution_contact.dart';

class GovernmentInstitution extends Equatable {
  final int id;
  final String name;
  final List<GovernmentInstitutionContact> governmentInstitutionContacts;

  const GovernmentInstitution({
    this.id = 0,
    this.name = '',
    this.governmentInstitutionContacts = const [],
  });

  factory GovernmentInstitution.fromJson(Map<String, dynamic> json) {
    final contactsData =
        json['governmentInstitutionContacts'] as List<dynamic>?;
    return GovernmentInstitution(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      governmentInstitutionContacts:
          contactsData
              ?.map(
                (e) => GovernmentInstitutionContact.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [id, name, governmentInstitutionContacts];
}
