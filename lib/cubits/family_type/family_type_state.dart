import 'package:flutter/material.dart';

import '../../models/family_type.dart';

@immutable
abstract class FamilyTypeState {}

class FamilyTypeInitial extends FamilyTypeState {}

class FamilyTypeLoaded extends FamilyTypeState {
  final List<FamilyType> familyTypes;

  FamilyTypeLoaded({
    required this.familyTypes,
  });
}

class FamilyTypeLoading extends FamilyTypeState {}

class FamilyTypeFailure extends FamilyTypeState {
  final String errorMessage;
  FamilyTypeFailure({
    required this.errorMessage,
  });
}
