import 'package:flutter/material.dart';

@immutable
abstract class GovernmentInstitutionContactState {}

class GovernmentInstitutionContactInitial
    extends GovernmentInstitutionContactState {}

class GovernmentInstitutionContactLoading
    extends GovernmentInstitutionContactState {}

class WaitAddedUpdatedGovernmentInstitutionContact
    extends GovernmentInstitutionContactState {}

class WaitDeleteGovernmentInstitutionContact
    extends GovernmentInstitutionContactState {}

class GovernmentInstitutionContactFailure
    extends GovernmentInstitutionContactState {
  final String errorMessage;
  GovernmentInstitutionContactFailure({required this.errorMessage});
}

class DeleteGovernmentInstitutionContactFailure
    extends GovernmentInstitutionContactState {
  final String errorMessage;
  DeleteGovernmentInstitutionContactFailure({required this.errorMessage});
}

class GovernmentInstitutionContactAddedSuccessfully
    extends GovernmentInstitutionContactState {
  final String message;
  GovernmentInstitutionContactAddedSuccessfully({required this.message});
}

class GovernmentInstitutionContactUpdatedSuccessfully
    extends GovernmentInstitutionContactState {
  final String message;
  GovernmentInstitutionContactUpdatedSuccessfully({required this.message});
}

class GovernmentInstitutionContactDeletedSuccessfully
    extends GovernmentInstitutionContactState {
  final String message;
  GovernmentInstitutionContactDeletedSuccessfully({required this.message});
}
