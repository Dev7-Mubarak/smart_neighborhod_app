import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member2.dart';

import '../../../confilct/data/models/conflict_case.dart';

@immutable
abstract class FamilyMemberState {}

class FamilyMemberInitial extends FamilyMemberState {}

class FamilyMemberLoaded extends FamilyMemberState {
  final List<FamilyMember2> familyMembers;

  FamilyMemberLoaded({required this.familyMembers});
}

class FamilyMemberLoading extends FamilyMemberState {}

class FamilyMemberFailure extends FamilyMemberState {
  final String errorMessage;
  FamilyMemberFailure({required this.errorMessage});
}

class ConflictCasesLoaded extends FamilyMemberState {
  final List<ConflictCase> conflictCases;
  ConflictCasesLoaded({required this.conflictCases});
}

class ConflictCasesLoading extends FamilyMemberState {}

class ConflictFailureTest extends FamilyMemberState {
  final String errorMessage;
  ConflictFailureTest({required this.errorMessage});
}
