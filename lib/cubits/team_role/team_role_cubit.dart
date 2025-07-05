import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/errors/errormodel.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_member.dart';
import 'package:smart_negborhood_app/models/team_role.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import 'team_role_state.dart';

class TeamRoleCubit extends Cubit<TeamRoleState> {
  TeamRoleCubit({required this.api}) : super(TeamRoleInitial());
  static TeamRoleCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  // Team? team;
  // // int? selectedTeamLeadId;
  // int? selectedPersonId;
  // DateTime? selectedJoiedDate;

  Future<void> getAllTeamRoles() async {
    emit(TeamRoleLoading());
    try {
      final response = await api.get(ApiLink.getAllTeamRoles);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      List<dynamic> teamsRoleJson = response["data"];
      List<TeamRole> teamRolesObjects = teamsRoleJson.map((e) => TeamRole.fromJson(e)).toList();
      if (teamRolesObjects.isEmpty) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "لا توجد فرق ",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      emit(TeamRoleLoaded(teamRolesObjects));
    } on Serverexception catch (e) {
      emit(TeamRoleFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamRoleFailure(errorMessage: e.toString()));
    }
  }

  // Future<void> setTeamForUpdate(Team team) async {
  //   this.team = team;
  //   TeamMember? teamLeader = team.teamMembers.firstWhere(
  //     (member) => member.teamRoleId == 1,
  //   );
  //   selectedJoiedDate = teamLeader.dateOfJoin;
  //   selectedPersonId = teamLeader.personId;
  // }

  // void changeSelectedManager(int? id) {
  //   selectedTeamLeadId = id;
  //   emit(ChangeSelectedTeamLeadId());
  // }
  // void changeSelectedManager(int? id) {
  //   selectedPersonId = id;
  //   emit(ChangeSelectedTeamLeadId());
  // }

  // void pickDate(BuildContext context) async {
  //   final DateTime now = DateTime.now();
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedJoiedDate ?? now,
  //     firstDate: DateTime(now.year - 5, now.month, now.day),
  //     lastDate: DateTime(2100, 12, 31),
  //   );

  //   if (picked != null && picked != selectedJoiedDate) {
  //     selectedJoiedDate = picked;
  //   }
  //   emit(ChangeSelectedJoiedDate());
  // }

  // Future<void> addNewTeam(String name) async {
  //   emit(TeamLoading());
  //   try {
  //     final response = await api.post(
  //       ApiLink.addTeam,
  //       data: {
  //         'name': name,
  //         'teamLeadId': selectedPersonId,
  //         "inJoiedDate": selectedJoiedDate?.toIso8601String(),
  //       },
  //     );

  //     if (response["isSuccess"]) {
  //       emit(
  //         TeamAddedSuccessfully(
  //           message: response["message"] ?? "تمت الإضافة بنجاح",
  //         ),
  //       );
  //       resetInputs();
  //       await getAllTeams();
  //     } else {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: response["statusCode"] ?? '400',
  //           errorMessage: response["message"] ?? "حدث خطأ غير معروف",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //   } on Serverexception catch (e) {
  //     emit(TeamFailure(errorMessage: e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(TeamFailure(errorMessage: e.toString()));
  //   }
  // }

  // void resetInputs() {
  //   team = null;
  //   selectedPersonId = null;
  //   selectedJoiedDate = null;
  // }

  // Future<void> updateTeams({required int id, String? name}) async {
  //   emit(TeamLoading());
  //   try {
  //     final response = await api.update(
  //       '${ApiLink.updateTeam}/$id',
  //       data: {
  //         'name': name,
  //         'teamLeadId': selectedPersonId,
  //         "inJoiedDate": selectedJoiedDate?.toIso8601String(),
  //       },
  //     );
  //     if (response["isSuccess"]) {
  //       emit(
  //         TeamUpdatedSuccessfully(
  //           message: response["message"] ?? "تم التحديث بنجاح",
  //         ),
  //       );
  //       resetInputs();
  //       await getAllTeams();
  //     } else {
  //       final String errorMessage =
  //           response["message"] ?? "حدث خطأ غير معروف أثناء تحديث المشروع";
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: response["statusCode"]?.toString() ?? '400',
  //           errorMessage: errorMessage,
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //   } on Serverexception catch (e) {
  //     emit(TeamFailure(errorMessage: e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(TeamFailure(errorMessage: e.toString()));
  //   }
  // }

  // Future<void> deleteTeam(int id) async {
  //   emit(TeamLoading());
  //   try {
  //     final response = await api.delete('${ApiLink.deleteTeam}/$id');

  //     if (response["isSuccess"]) {
  //       emit(TeamDeletedSuccessfully(message: response["message"]));
  //       await getAllTeams();
  //     } else {
  //       Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: response["statusCode"]?.toString() ?? '400',
  //           errorMessage: response["message"],
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //   } on Serverexception catch (e) {
  //     emit(TeamFailure(errorMessage: e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(TeamFailure(errorMessage: e.toString()));
  //   }
  // }
}
