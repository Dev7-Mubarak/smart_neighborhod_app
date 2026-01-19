import 'package:flutter/material.dart';
import '../../data/models/government_institution.dart';

@immutable
abstract class GovernmentInstitutionState {}

class GovernmentInstitutionInitial extends GovernmentInstitutionState {}

class GovernmentInstitutionLoaded extends GovernmentInstitutionState {
  final List<GovernmentInstitution> allGovernmentInstitutions;
  final List<GovernmentInstitution> filteredGovernmentInstitutions;
  GovernmentInstitutionLoaded({
    required this.allGovernmentInstitutions,
    required this.filteredGovernmentInstitutions,
  });
}

class GovernmentInstitutionLoading extends GovernmentInstitutionState {}

class WaitAddedUpdatedGovernmentInstitution
    extends GovernmentInstitutionState {}

class WaitDeleteGovernmentInstitution extends GovernmentInstitutionState {}

class GovernmentInstitutionFailure extends GovernmentInstitutionState {
  final String errorMessage;
  GovernmentInstitutionFailure({required this.errorMessage});
}

class DeleteGovernmentInstitutionFailure extends GovernmentInstitutionState {
  final String errorMessage;
  DeleteGovernmentInstitutionFailure({required this.errorMessage});
}

class GovernmentInstitutionAddedSuccessfully
    extends GovernmentInstitutionState {
  final String message;
  GovernmentInstitutionAddedSuccessfully({required this.message});
}

class GovernmentInstitutionUpdatedSuccessfully
    extends GovernmentInstitutionState {
  final String message;
  GovernmentInstitutionUpdatedSuccessfully({required this.message});
}

class GovernmentInstitutionDeletedSuccessfully
    extends GovernmentInstitutionState {
  final String message;
  GovernmentInstitutionDeletedSuccessfully({required this.message});
}
