import 'package:flutter/material.dart';

import '../../models/family.dart';

@immutable
abstract class FamilyState {}

class FamilyInitial extends FamilyState {}

class FamilysLoaded extends FamilyState {
  final List<Family> families;
  final bool? hasNextPage;

  FamilysLoaded({
    required this.families,
    this.hasNextPage,
  });
}

class FamilyLoading extends FamilyState {}

class FamilyFailure extends FamilyState {
  final String errorMessage;
  FamilyFailure({
    required this.errorMessage,
  });
}

class FamilyAddedSuccessfully extends FamilyState {
  final String message;
  FamilyAddedSuccessfully({required this.message});
}
