import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/project.dart';
import 'package:smart_negborhood_app/models/team.dart';

@immutable
abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamLoaded extends TeamState {
    final List<Team> allTeams;
  final List<Team> filteredTeams;
  TeamLoaded({required this.allTeams, required this.filteredTeams});

}

class ProjectsOfTeamLoaded extends TeamState {
    final List<Project> allProjects;
  ProjectsOfTeamLoaded({required this.allProjects});

}

class TeamLoading extends TeamState {}

class TeamFailure extends TeamState {
  final String errorMessage;
  TeamFailure({required this.errorMessage});
}

class TeamAddedSuccessfully extends TeamState {
  final String message;
  TeamAddedSuccessfully({required this.message});
}

class ChangeSelectedJoiedDate extends TeamState {}

class ChangeSelectedTeamLeadId extends TeamState {}

class TeamUpdatedSuccessfully extends TeamState {
  final String message;
  TeamUpdatedSuccessfully({required this.message});
}

class TeamDeletedSuccessfully extends TeamState {
  final String message;
  TeamDeletedSuccessfully({required this.message});
}
class TeamByIdLoaded extends TeamState {
  final Team team;
  TeamByIdLoaded({required this.team});
}

