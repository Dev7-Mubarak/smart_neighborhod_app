import 'package:flutter/material.dart';

import '../../../confilct/data/models/conflict_case.dart';
import '../../data/models/family_member.dart';

@immutable
abstract class FamilyMemberState {}

class FamilyMemberInitial extends FamilyMemberState {}

class FamilyMemberLoaded extends FamilyMemberState {
  final List<FamilyMember> familyMembers;

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
