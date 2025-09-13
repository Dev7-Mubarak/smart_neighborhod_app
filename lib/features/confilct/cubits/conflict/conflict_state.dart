import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';

@immutable
abstract class ConflictState {}

class ConflictInitial extends ConflictState {}

class ConflictLoaded extends ConflictState {
  final List<Conflict> allConflicts;
  final List<Conflict> filteredConflicts;
  ConflictLoaded({required this.allConflicts, required this.filteredConflicts});
}

class ConflictLoading extends ConflictState {}

class WiateAddedUpdatedConflict extends ConflictState {}
class WiateDeleteConflict extends ConflictState {}
class DeleteConflictFailure extends ConflictState {
  final String errorMessage;
  DeleteConflictFailure({required this.errorMessage});
}

class ConflictFailure extends ConflictState {
  final String errorMessage;
  ConflictFailure({required this.errorMessage});
}

class ConflictAddedSuccessfully extends ConflictState {
  final String message;
  ConflictAddedSuccessfully({required this.message});
}

class ChangeSelectedSessionDate extends ConflictState {}

class ChangeSelectedFirstPartyId extends ConflictState {}

class ChangeSelectedSecondPartyId extends ConflictState {}

class ChangeIsResolved extends ConflictState {}

class UplodeConflictPicture extends ConflictState {}

class ChangeSelectedConflictTypeId extends ConflictState {}

class ConflictUpdatedSuccessfully extends ConflictState {
  final String message;
  ConflictUpdatedSuccessfully({required this.message});
}

class ConfllictDeletedSuccessfully extends ConflictState {
  final String message;
  ConfllictDeletedSuccessfully({required this.message});
}
