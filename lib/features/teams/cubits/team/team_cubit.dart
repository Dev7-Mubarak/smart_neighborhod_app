import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team_member.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import '../../../Assistances/data/models/project.dart';
import 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit({required this.api}) : super(TeamInitial());
  static TeamCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Team? team;
  // int? selectedTeamLeadId;
  int? selectedPersonId;
  DateTime? selectedJoiedDate;
  List<Team> _allTeams = [];

  Future<void> addNewTeam(String name) async {
    emit(WiateAddedUpdatedTeam());
    try {
      final response = await api.post(
        ApiLink.addTeam,
        data: {
          'name': name,
          'teamLeadId': selectedPersonId,
          "inJoiedDate": selectedJoiedDate?.toIso8601String(),
        },
      );

      if (response["isSuccess"]) {
        emit(
          TeamAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
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
      emit(TeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getAllTeams({String? search}) async {
    emit(TeamLoading());
    try {
      final response = await api.get(ApiLink.getAllTeams);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      List<dynamic> teamsJson = response["data"];
      _allTeams = teamsJson.map((e) => Team.fromJson(e)).toList();

      if (_allTeams.isEmpty) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "لا توجد فرق ",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      if (search != null && search.isNotEmpty) {
        filterTeams(search);
      } else {
        emit(TeamLoaded(filteredTeams: _allTeams, allTeams: _allTeams));
      }
    } on Serverexception catch (e) {
      emit(TeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamFailure(errorMessage: e.toString()));
    }
  }


  Future<void> updateTeams({required int id,required String name}) async {
    emit(WiateAddedUpdatedTeam());
    try {
      final response = await api.update(
        '${ApiLink.updateTeam}/$id',
        data: {
          'name': name,
          'teamLeadId': selectedPersonId,
          "inJoiedDate": selectedJoiedDate?.toIso8601String(),
        },
      );
      if (response["isSuccess"]) {
        emit(
          TeamUpdatedSuccessfully(
            message: response["message"] ?? "تم التحديث بنجاح",
          ),
        );
        resetInputs();
      } else {
        final String errorMessage =
            response["message"] ?? "حدث خطأ غير معروف أثناء تحديث المشروع";
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"]?.toString() ?? '400',
            errorMessage: errorMessage,
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(TeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamFailure(errorMessage: e.toString()));
    }
  }

 Future<void> deleteTeam(int id) async {
    emit(TeamLoading());
    try {
      final response = await api.delete('${ApiLink.deleteTeam}/$id');

      if (response["isSuccess"]) {
        emit(TeamDeletedSuccessfully(message: response["data"]));
      } else {
       throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"]?.toString() ?? '400',
            errorMessage: response["message"],
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(TeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getProjectsByTeamId(int id) async {
    emit(TeamLoading());
    try {
      final response = await api.get(ApiLink.getProjectsByTeamId(teamId: id));

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      List<dynamic> ProjectJson = response["data"];
      List<Project> _allProjects = ProjectJson.map((e) => Project.fromJson(e)).toList();

      if (_allProjects.isEmpty) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "لا توجد مشاريع لهذا الفريق ",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      emit(ProjectsOfTeamLoaded( _allProjects));
    } on Serverexception catch (e) {
      emit(TeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamFailure(errorMessage: e.toString()));
    }
  }

  void filterTeams(String query) {
    if (query.isEmpty) {
      emit(TeamLoaded(allTeams: _allTeams, filteredTeams: _allTeams));
      return;
    }

    final filteredList = _allTeams
        .where((team) => team.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(TeamLoaded(allTeams: _allTeams, filteredTeams: filteredList));
  }

  Future<void> setTeamForUpdate(Team team) async {
    this.team = team;
    TeamMember? teamLeader = team.teamMembers.firstWhere(
      (member) => member.teamRoleId == 1,
    );
    selectedJoiedDate = teamLeader.dateOfJoin;
    selectedPersonId = teamLeader.personId;
  }

  void changeSelectedManager(int? id) {
    selectedPersonId = id;
    emit(ChangeSelectedTeamLeadId());
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
    emit(ChangeSelectedJoiedDate());
  }

  void resetInputs() {
    team = null;
    selectedPersonId = null;
    selectedJoiedDate = null;
  }

  Future<void> getTeamById(int id) async {
    emit(TeamLoading());
    try {
      final response = await api.get('${ApiLink.getTeamById}/$id');

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      ;
      emit(TeamByIdLoaded(team: Team.fromJson(response["data"])));
    } on Serverexception catch (e) {
      emit(TeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(TeamFailure(errorMessage: e.toString()));
    }
  }
}
