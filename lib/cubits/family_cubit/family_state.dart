import 'package:flutter/material.dart';

import '../../models/family.dart';
import '../../models/family_detiles_model.dart';

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

class FamilyAddedSuccessfully extends FamilyState {
  final String message;
  FamilyAddedSuccessfully({required this.message});
}

class changeFamilyHead extends FamilyState {}

class ChangeFamilyCategory extends FamilyState {}
