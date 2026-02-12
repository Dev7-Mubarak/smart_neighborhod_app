import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';

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
  final List<FamilyMember> allFamilyMembers;
  FamilyDetilesLoaded({
    required this.familyDetiles,
    required this.allFamilyMembers,
  });
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

class FamilyMemberDeletedSuccessfully extends FamilyState {
  final String message;
  FamilyMemberDeletedSuccessfully({required this.message});
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

class WaitingForUpdateOrAddFamily extends FamilyState {}

class FamilySyncedSuccessfully extends FamilyState {
  final String message;
  FamilySyncedSuccessfully({required this.message});
}

class FamilySyncFailed extends FamilyState {
  final String errorMessage;
  FamilySyncFailed({required this.errorMessage});
}
