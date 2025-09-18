import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/ProjectBlockFamilies.dart';
import 'package:smart_negborhood_app/features/Assistances/data/models/project_catgory.dart';
import 'package:smart_negborhood_app/features/teams/data/models/team.dart';

import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import '../../../../core/common/enums/project_priority.dart';
import '../../../../core/common/enums/project_status.dart';
import '../../data/models/project.dart';
import 'assistances_state.dart';

class AssistancesCubit extends Cubit<AssistancesState> {
  AssistancesCubit({required this.api}) : super(AssistancesInitial());
  static AssistancesCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Project? project;
  int? blockId;
  int? selectedManagerId;
  int? selectedTeam;
  int? selectedfamily;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  ProjectStatus? selectedProjectStatus;
  ProjectPriority? selectedProjectPriority;
  ProjectCategory? selectedProjectCategory;
  List<Project> _allProjects = [];
  List<Team> _allTeams = [];
  List<ProjectBlockFamilies> _allBlockFamilies = [];

  Future<void> getAssistances({String? search}) async {
    emit(AssistancesLoading());
    try {
      final response = await api.get(
        '${ApiLink.getAllProjects}?projectCategoryId=4',
        treat404AsEmptyList: true,
      );
      List<dynamic> projectsJson = response["data"];
      _allProjects = projectsJson.map((e) => Project.fromJson(e)).toList();

      if (search != null && search.isNotEmpty) {
        filterProjects(search);
      } else {
        emit(
          AssistancesLoaded(
            allProjects: _allProjects,
            filteredProjects: _allProjects,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }

  void filterProjects(String query) {
    if (query.isEmpty) {
      emit(
        AssistancesLoaded(
          allProjects: _allProjects,
          filteredProjects: _allProjects,
        ),
      );
      return;
    }

    final filteredList = _allProjects
        .where(
          (project) => project.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    emit(
      AssistancesLoaded(
        allProjects: _allProjects,
        filteredProjects: filteredList,
      ),
    );
  }

  Future<void> setAssistanceForUpdate(Project project) async {
    this.project = project;
    selectedStartDate = project.startDate;
    selectedEndDate = project.endDate;
    selectedProjectStatus = project.projectStatus;
    selectedProjectPriority = project.projectPriority;
    selectedProjectCategory = project.projectCategory;
    selectedManagerId = project.manager.id;
  }

  Future<void> setAssistanceForDetiles(Project project) async {
    this.project = project;
  }

  Future<void> setBlockIdForAddFamily(int blockid) async {
    blockId = blockid;
  }

  Future<void> deleteTeamFromeProject(int teamId) async {
    emit(WiateDeleteTeam());
    try {
      final response = await api.delete(
        ApiLink.removeTeamFromeProject(projectId: project!.id, teamId: teamId),
      );
      if (response["isSuccess"]) {
        emit(TeamDeletedSuccessfully(message: response["data"]));
        await getProjectTeams(id: project!.id);
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
      emit(DeleteTeamFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(DeleteTeamFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteFamilyFromeProject(int familyId) async {
    emit(WiateDeleteFamily());
    try {
      final response = await api.delete(
        ApiLink.removeFamilyFromeProject(
          projectId: project!.id,
          familyId: familyId,
        ),
      );

      if (response["isSuccess"]) {
        emit(FamilyDeletedSuccessfully(message: response["data"]));
        await getProjectBlockFamilies(id: project!.id);
        ;
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
      emit(DeleteFamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(DeleteFamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getProjectTeams({required int id}) async {
    emit(ProjectTeamsLoading());
    try {
      final response = await api.get(
        '${ApiLink.getProjectTeams}/$id',
        treat404AsEmptyList: true,
      );
      List<dynamic> teamsJson = response["data"];
      _allTeams = teamsJson.map((e) => Team.fromJson(e)).toList();
      emit(TeamsLoaded(teams: _allTeams));
    } on Serverexception catch (e) {
      emit(ProjectTeamsFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ProjectTeamsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getProjectBlockFamilies({required int id}) async {
    emit(BlockFamiliesLoading());
    try {
      final response = await api.get(
        ApiLink.getProjectBlockFamilies(projectId: id),
      );
      List<dynamic> BlockFamiliesJson = response["data"];
      _allBlockFamilies = BlockFamiliesJson.map(
        (e) => ProjectBlockFamilies.fromJson(e),
      ).toList();
      emit(BlockFamiliesLoaded(BlockFamilies: _allBlockFamilies));
    } on Serverexception catch (e) {
      emit(BlockFamiliesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(BlockFamiliesFailure(errorMessage: e.toString()));
    }
  }

  void changeSelectedManager(int? id) {
    selectedManagerId = id;

    emit(ChangeSelectedManager());
  }

  void changeSelectedTeam(int? id) {
    selectedTeam = id;
    emit(ChangeSelectedTeam());
  }

  void changeSelectedFamily(int? id) {
    selectedfamily = id;
    emit(ChangeSelectedFamily());
  }

  void changeSelectedProjectCategory(ProjectCategory? selectedManager) {
    selectedProjectCategory = selectedManager;
    emit(ChangeSelectedProjectCategory());
  }

  void changeSelectedProjectStatus(ProjectStatus? selectedProjectStatus) {
    this.selectedProjectStatus = selectedProjectStatus;
    emit(ChangeSelectedProjectStatus());
  }

  void changeSelectedProjectPriority(ProjectPriority? selectedProjectPriority) {
    this.selectedProjectPriority = selectedProjectPriority;
    emit(ChangeSelectedProjectPriority());
  }

  void pickStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? now,
      firstDate: DateTime(now.year - 5, now.month, now.day),
      lastDate: DateTime(2100, 12, 31),
    );

    if (picked != null && picked != selectedStartDate) {
      selectedStartDate = picked;
    }
    emit(ChangeSelectedStartDate());
  }

  void pickEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? now,
      firstDate: DateTime(now.year - 5, now.month, now.day),
      lastDate: DateTime(2100, 12, 31),
    );
    if (picked != null && picked != selectedEndDate) {
      selectedEndDate = picked;
    }
    emit(ChangeSelectedEndDate());
  }

  Future<void> addNewAssistances(
    String name,
    String description,
    int budget,
  ) async {
    emit(WiateAddedUpdatedassistance());
    try {
      final response = await api.post(
        ApiLink.addProject,
        data: {
          'name': name,
          'description': description,
          'managerId': selectedManagerId,
          "projectCatgoryId": selectedProjectCategory?.id,
          "startDate": selectedStartDate?.toIso8601String(),
          "endDate": selectedEndDate?.toIso8601String(),
          "projectStatus": selectedProjectStatus?.toString().split('.').last,
          "budget": budget,
          "projectPriority": selectedProjectPriority
              ?.toString()
              .split('.')
              .last,
        },
      );

      if (response["isSuccess"]) {
        emit(
          AssistancAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
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
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> assignTeamToAssistance() async {
    emit(WiateAssignTeamToAssistance());
    try {
      final response = await api.post(
        ApiLink.assignTeamToProject(
          projectId: project!.id,
          teamId: selectedTeam!,
        ),
      );

      if (response["isSuccess"]) {
        emit(
          TeamAssignedSuccessfully(
            message: response["data"] ?? "تم إضافة الفريق بنجاح",
          ),
        );
        await getProjectTeams(id: project!.id);
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
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> assignFamilyToAssistance() async {
    emit(WiateAssignFamilyToAssistance());
    try {
      final response = await api.post(
        ApiLink.assignFamilyToProject(
          projectId: project!.id,
          familyId: selectedfamily!,
        ),
      );

      if (response["isSuccess"]) {
        emit(
          FamilyAssignedSuccessfully(
            message: response["data"] ?? "تم إضافة الأسرة بنجاح",
          ),
        );
        await getProjectBlockFamilies(id: project!.id);
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
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }

  void resetInputs() {
    project = null;
    selectedManagerId = null;
    selectedStartDate = null;
    selectedEndDate = null;
    selectedProjectStatus = null;
    selectedProjectPriority = null;
    selectedProjectCategory = null;
  }

  Future<void> updateAssistances({
    required int id,
    String? name,
    String? description,
    int? budget,
  }) async {
    emit(WiateAddedUpdatedassistance());
    try {
      final response = await api.update(
        '${ApiLink.updateProject}/$id',
        data: {
          'name': name,
          'description': description,
          'managerId': selectedManagerId,
          "projectCatgoryId": selectedProjectCategory?.id,
          "startDate": selectedStartDate?.toIso8601String(),
          "endDate": selectedEndDate?.toIso8601String(),
          "projectStatus": selectedProjectStatus?.toString().split('.').last,
          "budget": budget,
          "projectPriority": selectedProjectPriority
              ?.toString()
              .split('.')
              .last,
        },
      );
      if (response["isSuccess"]) {
        emit(
          AssistanceUpdatedSuccessfully(
            message: response["data"] ?? "تم التحديث بنجاح",
          ),
        );
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
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteAssistance(int id) async {
    emit(WiatedeleteAssistance());
    try {
      final response = await api.delete('${ApiLink.deleteProject}/$id');

      if (response["isSuccess"]) {
        emit(AssistancDeletedSuccessfully(message: response["data"]));
        await getAssistances();
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
      emit(DeleteAssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(DeleteAssistancesFailure(errorMessage: e.toString()));
    }
  }
}
