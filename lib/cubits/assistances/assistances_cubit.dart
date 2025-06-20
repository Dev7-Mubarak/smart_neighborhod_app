import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_neighborhod_app/core/errors/errormodel.dart';
import 'package:smart_neighborhod_app/models/Person.dart';
import 'package:smart_neighborhod_app/models/project_catgory.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/API/dio_consumer.dart';
import '../../../core/errors/exception.dart';
import '../../models/enums/project_priority.dart';
import '../../models/enums/project_status.dart';
import '../../models/project.dart';
import 'assistances_state.dart';

class AssistancesCubit extends Cubit<AssistancesState> {
  AssistancesCubit({required this.api}) : super(AssistancesInitial());
  static AssistancesCubit get(context) => BlocProvider.of(context);

  DioConsumer api;
  Project? project;
  // Person? selectedManager;
  int? selectedManagerId;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  ProjectStatus? selectedProjectStatus;
  ProjectPriority? selectedProjectPriority;
  ProjectCategory? selectedProjectCategory;

  Future<void> getAssistances({String? search}) async {
    emit(AssistancesLoading());
    try {
      final response = await api.get(
        ApiLink.getAllProjects,
      );

      if (response["data"] == null) {
        throw Serverexception(
            errModel: ErrorModel(
                statusCode: '400',
                errorMessage: "No data received",
                isSuccess: response["isSuccess"] ?? false)
            );
      }
      List<dynamic> _projectsJson = response["data"];
      List<Project> _projectsObjects =
          _projectsJson.map((e) => Project.fromJson(e)).toList();    
      List<Project> _assistances = _projectsObjects
          .where((e) => e.projectCategory.name == "مساعدات")
          .toList();
      if (_assistances == []) {
        throw Serverexception(
            errModel: ErrorModel(
                statusCode: '400',
                errorMessage: "لا توجد مشاريع مساعدات",
                isSuccess: response["isSuccess"] ?? false));
      }
      emit(AssistancesLoaded(_assistances));
    } on Serverexception catch (e) {
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> setAssistanceForUpdate(Project project) async {
    this.project = project;
    selectedStartDate = project.startDate;
    selectedEndDate = project.endDate;
    selectedProjectStatus = project.projectStatus;
    selectedProjectPriority = project.projectPriority;
    selectedProjectCategory = project.projectCategory;
    selectedManagerId = project.manager.id;
    // final response = await api.get(
    //   '${ApiLink.getPersonById}/${project.manager.id}',
    // );
    // if (response["data"] != null) {
    //   selectedManager = Person.fromJson(response["data"]);
    // }
  }

  // void changeSelectedManager(Person? selectedManager) {
  //   this.selectedManager = selectedManager;
  //   emit(ChangeSelectedManager());
  // }
  // دالة لتغيير المدير المختار بناءً على الـ ID
  void changeSelectedManager(int? id) {
    selectedManagerId = id;
  
    // يمكنك هنا إطلاق حالة جديدة إذا كنت بحاجة إلى تحديث واجهة المستخدم
    // emit(PersonIdSelectedState(id));
    emit(ChangeSelectedManager());
  }

  void changeSelectedProjectCategory(ProjectCategory? selectedManager) {
    this.selectedProjectCategory = selectedManager;
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
        lastDate: DateTime(2100, 12, 31));

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
        lastDate: DateTime(2100, 12, 31));
    if (picked != null && picked != selectedEndDate) {
      selectedEndDate = picked;
    }
    emit(ChangeSelectedEndDate());
  }

  Future<void> addNewAssistances(
      String name, String description, int budget) async {
    emit(AssistancesLoading());
    try {
      final response = await api.post(
        ApiLink.addProject,
        data: {
          'name': name,
          'description': description,
          // 'managerId': selectedManager?.id,
          'managerId': selectedManagerId,
          "projectCatgoryId": selectedProjectCategory?.id,
          "startDate": selectedStartDate?.toIso8601String(),
          "endDate": selectedEndDate?.toIso8601String(),
          "projectStatus": selectedProjectStatus?.toString().split('.').last,
          "budget": budget,
          "projectPriority":
              selectedProjectPriority?.toString().split('.').last,
        },
      );

      if (response["isSuccess"]) {
        emit(AssistancAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح"));
        resetInputs();
        await getAssistances();
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
    // selectedManager = null;
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
    emit(AssistancesLoading());
    try {
      final response = await api.update(
        '${ApiLink.updateProject}/$id',
        data: {
          'name': name,
          'description': description,
          // 'managerId': selectedManager?.id,
          'managerId': selectedManagerId,
          "projectCatgoryId": selectedProjectCategory?.id,
          "startDate": selectedStartDate?.toIso8601String(),
          "endDate": selectedEndDate?.toIso8601String(),
          "projectStatus": selectedProjectStatus?.toString().split('.').last,
          "budget": budget,
          "projectPriority":
              selectedProjectPriority?.toString().split('.').last,
        },
      );
      if (response["isSuccess"]) {
        emit(AssistanceUpdatedSuccessfully(
            message: response["message"] ?? "تم التحديث بنجاح"));
        resetInputs();
        await getAssistances();
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
    emit(AssistancesLoading());
    try {
      final response = await api.delete(
        '${ApiLink.deleteProject}/$id',
      );

      if (response["isSuccess"]) {
        emit(AssistancDeletedSuccessfully(message: response["message"]));
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
      emit(AssistancesFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(AssistancesFailure(errorMessage: e.toString()));
    }
  }
}
