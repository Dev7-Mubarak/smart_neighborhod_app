import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/project.dart';

@immutable
abstract class AssistancesState {}

class AssistancesInitial extends AssistancesState {}

class AssistancesLoaded extends AssistancesState {
  final List<Project> allProjects;

  final List<Project> filteredProjects;
  AssistancesLoaded({required this.allProjects, required this.filteredProjects});
}

class AssistancesLoading extends AssistancesState {}

class AssistancesFailure extends AssistancesState {
  final String errorMessage;
  AssistancesFailure({required this.errorMessage});
}

class AssistancAddedSuccessfully extends AssistancesState {
  final String message;
  AssistancAddedSuccessfully({required this.message});
}

class AssistancDeletedSuccessfully extends AssistancesState {
  final String message;
  AssistancDeletedSuccessfully({required this.message});
}

class ChangeSelectedManager extends AssistancesState {}

class ChangeSelectedProjectCategory extends AssistancesState {}

class ChangeSelectedProjectStatus extends AssistancesState {}

class ChangeSelectedProjectPriority extends AssistancesState {}

class ChangeSelectedStartDate extends AssistancesState {}

class ChangeSelectedEndDate extends AssistancesState {}

class AssistanceUpdatedSuccessfully extends AssistancesState {
  final String message;
  AssistanceUpdatedSuccessfully({required this.message});
}
