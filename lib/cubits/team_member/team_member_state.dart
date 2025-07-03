import 'package:flutter/material.dart';
import 'package:smart_negborhood_app/models/team_member.dart';

@immutable
abstract class TeamMemberState {}

class TeamInitial extends TeamMemberState {}

class TeamMemberLoaded extends TeamMemberState {
  final List<TeamMember> allTeamMembers;

  TeamMemberLoaded(this.allTeamMembers);
}

class TeamMemberLoading extends TeamMemberState {}

class TeamMemberFailure extends TeamMemberState {
  final String errorMessage;
  TeamMemberFailure({required this.errorMessage});
}

class TeamMemberAddedSuccessfully extends TeamMemberState {
  final String message;
  TeamMemberAddedSuccessfully({required this.message});
}

class ChangeSelectedMemberJoiedDate extends TeamMemberState {}

class ChangeSelectedPersonId extends TeamMemberState {}
class ChangeSelectedTeamRoleId extends TeamMemberState {}

class TeamMemberUpdatedSuccessfully extends TeamMemberState {
  final String message;
  TeamMemberUpdatedSuccessfully({required this.message});
}

class TeamMemberDeletedSuccessfully extends TeamMemberState {
  final String message;
  TeamMemberDeletedSuccessfully({required this.message});
}
