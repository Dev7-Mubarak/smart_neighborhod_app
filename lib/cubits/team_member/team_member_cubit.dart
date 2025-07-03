import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/errors/errormodel.dart';
import 'package:smart_negborhood_app/models/project_catgory.dart';
import 'package:smart_negborhood_app/models/team.dart';
import 'package:smart_negborhood_app/models/team_member.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../models/enums/project_priority.dart';
import '../../models/enums/project_status.dart';
import '../../models/project.dart';
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

  // Future<void> getAllTeams() async {
  //   emit(TeamLoading());
  //   try {
  //     final response = await api.get(ApiLink.getAllTeams);
  //     if (response["data"] == null) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: '400',
  //           errorMessage: "No data received",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     List<dynamic> teamsJson = response["data"];
  //     List<Team> teamsObjects = teamsJson.map((e) => Team.fromJson(e)).toList();
  //     // List<Project> assistances = projectsObjects
  //     //     .where((e) => e.projectCategory.name == "مساعدات")
  //     //     .toList();
  //     if (teamsObjects.isEmpty) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: '400',
  //           errorMessage: "لا توجد فرق ",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     emit(TeamLoaded(teamsObjects));
  //   } on Serverexception catch (e) {
  //     emit(TeamFailure(errorMessage: e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(TeamFailure(errorMessage: e.toString()));
  //   }
  // }

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
    emit(TeamMemberLoading());
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
    emit(TeamMemberLoading());
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
