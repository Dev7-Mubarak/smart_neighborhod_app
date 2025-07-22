import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/conflict_type.dart';

@immutable
abstract class ConflictTypeState {}

class ConflictTypeInitial extends ConflictTypeState {}

class ConflictTypeLoaded extends ConflictTypeState {
  final List<ConflictType> conflictTypes;
  ConflictTypeLoaded({required this.conflictTypes});
}

class ConflictTypeLoading extends ConflictTypeState {}

class ConflictTypeFailure extends ConflictTypeState {
  final String errorMessage;
  ConflictTypeFailure({required this.errorMessage});
}
