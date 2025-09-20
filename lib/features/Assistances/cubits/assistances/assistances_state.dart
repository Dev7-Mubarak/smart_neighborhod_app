import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/ProjectBlockFamilies.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';

@immutable
abstract class AssistancesState {}

class AssistancesInitial extends AssistancesState {}

class TeamsLoaded extends AssistancesState {
  final List<Team> teams;
  TeamsLoaded({required this.teams});
}

class BlockFamiliesLoaded extends AssistancesState {
  final List<ProjectBlockFamilies> BlockFamilies;
  BlockFamiliesLoaded({required this.BlockFamilies});
}

class AssistancesLoaded extends AssistancesState {
  final List<Project> allProjects;

  final List<Project> filteredProjects;

  AssistancesLoaded({
    required this.allProjects,
    required this.filteredProjects,
  });
}

class AssistancesLoading extends AssistancesState {}

class ProjectTeamsLoading extends AssistancesState {}

class BlockFamiliesLoading extends AssistancesState {}
class WiatedeleteAssistance extends AssistancesState {}

class AssistancesFailure extends AssistancesState {
  final String errorMessage;
  AssistancesFailure({required this.errorMessage});
}

class DeleteFamilyFailure extends AssistancesState {
  final String errorMessage;
  DeleteFamilyFailure({required this.errorMessage});
}
class DeleteAssistancesFailure extends AssistancesState {
  final String errorMessage;
  DeleteAssistancesFailure({required this.errorMessage});
}
class DeleteTeamFailure extends AssistancesState {
  final String errorMessage;
  DeleteTeamFailure({required this.errorMessage});
}

class ProjectTeamsFailure extends AssistancesState {
  final String errorMessage;
  ProjectTeamsFailure({required this.errorMessage});
}

class BlockFamiliesFailure extends AssistancesState {
  final String errorMessage;
  BlockFamiliesFailure({required this.errorMessage});
}

class AssistancAddedSuccessfully extends AssistancesState {
  final String message;
  AssistancAddedSuccessfully({required this.message});
}

class AssistancDeletedSuccessfully extends AssistancesState {
  final String message;
  AssistancDeletedSuccessfully({required this.message});
}

class TeamDeletedSuccessfully extends AssistancesState {
  final String message;
  TeamDeletedSuccessfully({required this.message});
}

class FamilyDeletedSuccessfully extends AssistancesState {
  final String message;
  FamilyDeletedSuccessfully({required this.message});
}

class ChangeSelectedManager extends AssistancesState {}

class ChangeSelectedTeam extends AssistancesState {}

class ChangeSelectedFamily extends AssistancesState {}

class ChangeSelectedProjectCategory extends AssistancesState {}

class ChangeSelectedProjectStatus extends AssistancesState {}

class ChangeSelectedProjectPriority extends AssistancesState {}

class ChangeSelectedStartDate extends AssistancesState {}

class WiateAssignFamilyToAssistance extends AssistancesState {}

class WiateAssignTeamToAssistance extends AssistancesState {}
class WiateDeleteFamily extends AssistancesState {}
class WiateDeleteTeam extends AssistancesState {}

class ChangeSelectedEndDate extends AssistancesState {}

class WiateAddedUpdatedassistance extends AssistancesState {}

class TeamAssignedSuccessfully extends AssistancesState {
  final String message;
  TeamAssignedSuccessfully({required this.message});
}

class FamilyAssignedSuccessfully extends AssistancesState {
  final String message;
  FamilyAssignedSuccessfully({required this.message});
}

class AssistanceUpdatedSuccessfully extends AssistancesState {
  final String message;
  AssistanceUpdatedSuccessfully({required this.message});
}
