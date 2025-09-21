import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict_case.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/errors/exception.dart';
import 'dart:async';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../data/models/family.dart';
import '../../data/models/family_detiles_model.dart';

class FamilyCubit extends Cubit<FamilyState> {
  final DioConsumer api;
  FamilyCubit(this.blockId, {required this.api}) : super(FamilyInitial());

  static FamilyCubit get(context) => BlocProvider.of(context);

  List<Family> allFamilies = [];
  final int blockId;
  int? selectedFamilyHeadId;
  int? selectedCategoryId;
  Family? family;
  FamilyMember? familyMember;

  void setFamily(Family? family) {
    this.family = family;
  }

  void setFamilyMember(FamilyMember? familyMember) {
    this.familyMember = familyMember;
  }

  void changeSelectedFamilyCategory(int? selectedCategoryId) {
    this.selectedCategoryId = selectedCategoryId;
    emit(ChangeFamilyCategory());
  }

  void changeSelectedFamilyHead(int? selectedFamilyHeadId) {
    this.selectedFamilyHeadId = selectedFamilyHeadId;
    emit(ChangeFamilyHead());
  }

  Future<void> addNewFamily(Family family) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final response = await api.post(
        ApiLink.addFamily,
        data: {
          "name": family.name,
          "familyCatgoryId": this.selectedCategoryId,
          "location": family.location,
          "familyNotes": family.familyNotes,
          "blockId": family.blockId,
          "familyHeadId": this.selectedFamilyHeadId,
        },
      );

      if (response["isSuccess"]) {
        emit(FamilyAddedSuccessfully(message: "تم اضافة الاسرة بنجاح"));
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateFamily(Family family) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final response = await api.update(
        '${ApiLink.updateFamily}/${family.id}',
        data: {
          "name": family.name,
          "familyCatgoryId": this.selectedCategoryId,
          "location": family.location,
          "familyNotes": family.familyNotes,
          "blockId": family.blockId,
          "familyHeadId": this.selectedFamilyHeadId,
        },
      );

      if (response["isSuccess"]) {
        emit(FamilyUpdatedSuccessfully(message: "تم تحديث الأسرة بنجاح"));
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFamilyDetilesById(int id) async {
    emit(FamilyLoading());
    try {
      final response = await api.get(
        ApiLink.getFamilyDetailes,
        queryparameters: {"id": id},
      );

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      emit(
        FamilyDetilesLoaded(
          familyDetiles: FamilyDetilesModel.fromJson(response["data"]),
        ),
      );
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addFamilyMember({
    required int familyId,
    required int personId,
    required int roleId,
  }) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final response = await api.post(
        ApiLink.addFamilyMember,
        data: {"familyId": familyId, "personId": personId, "roleId": roleId},
      );

      if (response["isSuccess"]) {
        emit(
          FamilyMemberAddedSuccessfully(message: "تم إضافة الشخص للأسرة بنجاح"),
        );
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteFamily(int id) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final response = await api.delete('${ApiLink.deleteFamily}/$id');

      if (response["isSuccess"]) {
        emit(FamilyDeletedSuccessfully(message: "تم حذف الأسرة بنجاح"));
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFamiliesByBlockId() async {
    emit(FamilyLoading());
    try {
      final response = await api.get(ApiLink.getAllFamily);
      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      List<dynamic> familiesJson = response["data"];
      List<Family> familiesObjects = familiesJson
          .map((e) => Family.fromJson(e))
          .toList();
      if (familiesObjects == []) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: "لا توجد أسر",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
      allFamilies = familiesObjects.where((e) => e.blockId == blockId).toList();

      emit(FamilyLoaded(families: allFamilies));
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteFamilyMember(int familyId, int familyMemberId) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final response = await api.delete(
        '${ApiLink.getFamilyMembers}/$familyMemberId',
        queryparameters: {"familyId": familyId},
      );
      if (response["isSuccess"]) {
        emit(
          FamilyMemberDeletedSuccessfully(message: "تم حذف فرد الأسرة بنجاح"),
        );
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: '400',
            errorMessage: response["message"] ?? "حدث خطأ غير معروف",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } on Serverexception catch (e) {
      emit(FamilyFailure(errorMessage: e.errModel.errorMessage));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }
}
