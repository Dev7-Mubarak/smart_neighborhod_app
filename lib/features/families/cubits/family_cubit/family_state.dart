import 'package:flutter/material.dart';

import '../../../confilct/data/models/conflict_case.dart';
import '../../data/models/family.dart';
import '../../data/models/family_detiles_model.dart';

@immutable
abstract class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilyLoaded extends FamilyState {
  final List<Family> families;

  FamilyLoaded({required this.families});
}

class FamilyDetilesLoaded extends FamilyState {
  final FamilyDetilesModel familyDetiles;

  FamilyDetilesLoaded({required this.familyDetiles});
}

class FamilyLoading extends FamilyState {}

class FamilyFailure extends FamilyState {
  final String errorMessage;
  FamilyFailure({required this.errorMessage});
}

class FamilyDeletedSuccessfully extends FamilyState {
  final String message;
  FamilyDeletedSuccessfully({required this.message});
}

class FamilyAddedSuccessfully extends FamilyState {
  final String message;
  FamilyAddedSuccessfully({required this.message});
}

class FamilyUpdatedSuccessfully extends FamilyState {
  final String message;
  FamilyUpdatedSuccessfully({required this.message});
}

class FamilyMemberAddedSuccessfully extends FamilyState {
  final String message;
  FamilyMemberAddedSuccessfully({required this.message});
}

class ChangeFamilyHead extends FamilyState {}

class ChangeFamilyCategory extends FamilyState {}

class ChangeFamilyType extends FamilyState {}

class ConflictCasesLoaded extends FamilyState {
  final List<ConflictCase> conflictCases;
  ConflictCasesLoaded({required this.conflictCases});
}

class ConflictCasesLoading extends FamilyState {}
