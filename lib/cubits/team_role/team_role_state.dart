import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/project.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_role.dart';

@immutable
abstract class TeamRoleState {}

class TeamRoleInitial extends TeamRoleState {}

class TeamRoleLoaded extends TeamRoleState {
  final List<TeamRole> allTeamRoles;

  TeamRoleLoaded(this.allTeamRoles);
}

class TeamRoleLoading extends TeamRoleState {}

class TeamRoleFailure extends TeamRoleState {
  final String errorMessage;
  TeamRoleFailure({required this.errorMessage});
}

// class TeamAddedSuccessfully extends TeamState {
//   final String message;
//   TeamAddedSuccessfully({required this.message});
// }

// class ChangeSelectedJoiedDate extends TeamState {}

// class ChangeSelectedTeamLeadId extends TeamState {}

// class TeamUpdatedSuccessfully extends TeamState {
//   final String message;
//   TeamUpdatedSuccessfully({required this.message});
// }

// class TeamDeletedSuccessfully extends TeamState {
//   final String message;
//   TeamDeletedSuccessfully({required this.message});
// }
