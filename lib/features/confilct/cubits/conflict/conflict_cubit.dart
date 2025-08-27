import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_negborhood_app/core/services/errors/errormodel.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import 'conflict_state.dart';

class ConflictCubit extends Cubit<ConflictState> {
  ConflictCubit({required this.api}) : super(ConflictInitial());
  static ConflictCubit get(context) => BlocProvider.of(context);
  DioConsumer api;
  Conflict? conflict;
  int? selectedfirstPartId;
  int? selectedSecondPartId;
  int? selectedConflictTypeId;
  DateTime? sessionDate;
  bool? isResolved;
  XFile? conflictPicture;
  List<Conflict> _allconflicts = [];

  Future<void> getAllConflicts({String? search}) async {
    emit(ConflictLoading());
    try {
      final response = await api.get(ApiLink.getAllConflict);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      List<dynamic> conflictsJson = response["data"];
      _allconflicts = conflictsJson.map((e) => Conflict.fromJson(e)).toList();
      if (_allconflicts.isEmpty) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "لا توجد فرق ",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      if (search != null && search.isNotEmpty) {
        // filterTeams(search);
      } else {
        emit(
          ConflictLoaded(
            filteredConflicts: _allconflicts,
            allConflicts: _allconflicts,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(ConflictFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ConflictFailure(errorMessage: e.toString()));
    }
  }

  void filterTeams(String query) {
    if (query.isEmpty) {
      emit(
        ConflictLoaded(
          allConflicts: _allconflicts,
          filteredConflicts: _allconflicts,
        ),
      );
      return;
    }
    final filteredList = _allconflicts
        .where(
          (conflict) =>
              conflict.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    emit(
      ConflictLoaded(
        allConflicts: _allconflicts,
        filteredConflicts: filteredList,
      ),
    );
  }

  Future<void> setConflictForUpdate(Conflict conflict) async {
    this.conflict = conflict;
    sessionDate = conflict.sessionDate;
    selectedfirstPartId = conflict.firstPartyId;
    selectedSecondPartId = conflict.secondPartyId;
    selectedConflictTypeId = conflict.conflictTypeId;
    isResolved = conflict.isResolved;
    // conflictPicture= conflict.imageUrl;
  }

  // // void changeSelectedManager(int? id) {
  // //   selectedTeamLeadId = id;
  // //   emit(ChangeSelectedTeamLeadId());
  // // }
  void uplodeConflictPicture(XFile image) {
    conflictPicture = image;
    emit(UplodeConflictPicture());
  }

  void changeSelectedFirstParty(int? id) {
    selectedfirstPartId = id;
    emit(ChangeSelectedFirstPartyId());
  }

  void changeSelectedSecondParty(int? id) {
    selectedSecondPartId = id;
    emit(ChangeSelectedSecondPartyId());
  }

  void changeSelectedConflictType(int? id) {
    selectedConflictTypeId = id;
    emit(ChangeSelectedConflictTypeId());
  }

  void changeIsResolved(bool? isResolved) {
    this.isResolved = isResolved ?? false;
    emit(ChangeIsResolved());
  }

  void pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sessionDate ?? now,
      firstDate: DateTime(now.year - 5, now.month, now.day),
      lastDate: DateTime(2100, 12, 31),
    );

    if (picked != null && picked != sessionDate) {
      sessionDate = picked;
    }
    emit(ChangeSelectedSessionDate());
  }

  Future<void> addConflict(String notes, String title) async {
    emit(WiateAddedUpdatedConflict());
    try {
      final response = await api.post(
        '${ApiLink.addConflict}?ConflictTypeId=$selectedConflictTypeId&ManagerId=10b8ca7f-bf24-4609-9cfb-ee1dbc23f5bf&FirstPartyId=$selectedfirstPartId&SecondPartyId=$selectedSecondPartId&Notes=$notes&SessionDate=$sessionDate&Title=$title&IsResolved=${isResolved ?? false}',
        data: {
          'Image': conflictPicture != null
              ? await MultipartFile.fromFile(
                  conflictPicture!.path,
                  filename: conflictPicture!.name,
                )
              : null,
        },
        isFromData: true,
      );
      if (response["isSuccess"]) {
        emit(
          ConflictAddedSuccessfully(
            message: response["message"] ?? "تمت الإضافة بنجاح",
          ),
        );
        // getAllConflicts();
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
      emit(ConflictFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ConflictFailure(errorMessage: e.toString()));
    }
  }

  void resetInputs() {
    conflict = null;
    selectedfirstPartId = null;
    selectedSecondPartId = null;
    selectedConflictTypeId = null;
    sessionDate = null;
    isResolved = null;
    conflictPicture = null;
  }

  Future<void> updateConflict({
    required int id,
    required String title,
    required String notes,
  }) async {
    emit(WiateAddedUpdatedConflict());
    try {
      final response = await api.update(
        '${ApiLink.updateConflict}/$id?Title=$title&ConflictTypeId=$selectedConflictTypeId&ManagerId=10b8ca7f-bf24-4609-9cfb-ee1dbc23f5bf&FirstPartyId=$selectedfirstPartId&SecondPartyId=$selectedSecondPartId&Notes=$notes&SessionDate=$sessionDate&IsResolved=$isResolved',
        data: {
          'Image': conflictPicture != null
              ? await MultipartFile.fromFile(
                  conflictPicture!.path,
                  filename: conflictPicture!.name,
                )
              : null,
        },
        isFromData: true,
      );
      if (response["isSuccess"]) {
        emit(
          ConflictUpdatedSuccessfully(
            message: response["data"] ?? "تم التحديث بنجاح",
          ),
        );
        resetInputs();
        // getAllConflicts();
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
      emit(ConflictFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ConflictFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteConflict(int id) async {
    emit(ConflictLoading());
    try {
      final response = await api.delete('${ApiLink.deleteConflict}/$id');
      if (response["isSuccess"]) {
        emit(ConfllictDeletedSuccessfully(message: response["message"]));
        await getAllConflicts();
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
      emit(ConflictFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(ConflictFailure(errorMessage: e.toString()));
    }
  }

  // Future<void> getProjectsByTeamId(int id) async {
  //   emit(TeamLoading());
  //   try {
  //     final response = await api.get('${ApiLink.getProjectsByTeamId}/$id');
  //     if (response["data"] == null) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: '400',
  //           errorMessage: "No data received",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     List<dynamic> ProjectJson = response["data"];
  //     List<Project> _allProjects = ProjectJson.map((e) => Project.fromJson(e)).toList();
  //     if (_allProjects.isEmpty) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: '400',
  //           errorMessage: "لا توجد مشاريع لهذا الفريق ",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     emit(ProjectsOfTeamLoaded(allProjects: _allProjects));
  //   } on Serverexception catch (e) {
  //     emit(TeamFailure(errorMessage: e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(TeamFailure(errorMessage: e.toString()));
  //   }
  // }

  // Future<void> getTeamById(int id) async {
  //   emit(TeamLoading());
  //   try {
  //     final response = await api.get('${ApiLink.getTeamById}/$id');
  //     if (response["data"] == null) {
  //       throw Serverexception(
  //         errModel: ErrorModel(
  //           statusCode: '400',
  //           errorMessage: "No data received",
  //           isSuccess: response["isSuccess"] ?? false,
  //         ),
  //       );
  //     }
  //     ;
  //     emit(TeamByIdLoaded(team: Team.fromJson(response["data"])));
  //   } on Serverexception catch (e) {
  //     emit(TeamFailure(errorMessage: e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(TeamFailure(errorMessage: e.toString()));
  //   }
  // }
}
