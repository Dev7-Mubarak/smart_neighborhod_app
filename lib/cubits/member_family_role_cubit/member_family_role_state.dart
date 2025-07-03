import 'package:smart_negborhood_app/models/member_family_role.dart';

abstract class MemberFamilyRoleState {}

class MemberFamilyRoleInitial extends MemberFamilyRoleState {}

class MemberFamilyRoleLoading extends MemberFamilyRoleState {}

class MemberFamilyRoleLoaded extends MemberFamilyRoleState {
  final List<MemberFamilyRole> roles;
  MemberFamilyRoleLoaded(this.roles);
}

class MemberFamilyRoleFailure extends MemberFamilyRoleState {
  final String errorMessage;
  MemberFamilyRoleFailure(this.errorMessage);
}
