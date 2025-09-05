import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import 'team_member_state.dart';

class TeamMemberCubit extends Cubit<TeamMemberState> {
  TeamMemberCubit({required this.api}) : super(TeamInitial());
  static TeamMemberCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  TeamMember? teamMember;
  int? selectedPersonId;
  int? selectedTeamRoleId;
  DateTime? selectedJoiedDate;
  int? teamId;

  Future<void> setTeamId(int teamId) async {
    this.teamId = teamId;
  }

  Future<void> setTeamMemberForUpdate(TeamMember teamMember) async {
    this.teamMember = teamMember;
    teamId = teamMember.teamId;
    selectedPersonId = teamMember.personId;
    selectedTeamRoleId = teamMember.teamRoleId;
    selectedJoiedDate = teamMember.dateOfJoin;
  }

  void changeSelectedPerson(int? id) {
    selectedPersonId = id;
    emit(ChangeSelectedPersonId());
  }

  void changeSelectedTeamRole(int? id) {
    selectedTeamRoleId = id;
    emit(ChangeSelectedTeamRoleId());
  }

  void pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedJoiedDate ?? now,
      firstDate: DateTime(now.year - 5, now.month, now.day),
      lastDate: DateTime(2100, 12, 31),
    );

    if (picked != null && picked != selectedJoiedDate) {
      selectedJoiedDate = picked;
    }
    emit(ChangeSelectedMemberJoiedDate());
  }

  Future<void> addNewTeamMember() async {
    emit(WiateAddedUpdatedTeamMember());
    try {
      final response = await api.post(
        ApiLink.addTeamMember,
        data: {
          'teamId': teamId,
          'personId': selectedPersonId,
          "teamRoleId": selectedTeamRoleId,
          "dateOfJoin": selectedJoiedDate?.toIso8601String(),
        },
      );

      if (response["isSuccess"]) {
        emit(
          TeamMemberAddedSuccessfully(
            message: response["data"] ?? "تمت الإضافة بنجاح",
          ),
        );
        resetInputs();
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(TeamMemberFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamMemberFailure(errorMessage: e.toString()));
    }
  }

  void resetInputs() {
    teamMember = null;
    teamId = null;
    selectedPersonId = null;
    selectedTeamRoleId = null;
    selectedJoiedDate = null;
  }

  Future<void> updateTeamMember({required int id}) async {
    emit(WiateAddedUpdatedTeamMember());
    try {
      final response = await api.update(
        '${ApiLink.updateTeamMember}/$id',
        data: {
          'teamId': teamId,
          "teamRoleId": selectedTeamRoleId,
          "dateOfJoin": selectedJoiedDate?.toIso8601String(),
        },
      );
      if (response["isSuccess"]) {
        emit(
          TeamMemberUpdatedSuccessfully(
            message: response["data"] ?? "تم التحديث بنجاح",
          ),
        );
        resetInputs();
        // await getAllTeams();
      } else {
        final String errorMessage =
            response["message"] ?? "حدث خطأ غير معروف أثناء تحديث عضو الفريق";
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"]?.toString() ?? '400',
            errorMessage: errorMessage,
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(TeamMemberFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamMemberFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteTeamMember(int id) async {
    emit(TeamMemberLoading());
    try {
      final response = await api.delete('${ApiLink.deleteTeamMember}/$id');

      if (response["isSuccess"]) {
        emit(TeamMemberDeletedSuccessfully(message: response["message"]));
      } else {
        Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"]?.toString() ?? '400',
            errorMessage: response["message"],
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(TeamMemberFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamMemberFailure(errorMessage: e.toString()));
    }
  }
}
