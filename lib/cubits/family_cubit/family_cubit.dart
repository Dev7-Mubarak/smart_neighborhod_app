import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/models/family_type.dart';
import '../../../components/constants/api_link.dart';
import '../../../core/errors/exception.dart';
import 'dart:async';
import '../../core/API/dio_consumer.dart';
import '../../core/errors/errormodel.dart';
import '../../models/Person.dart';
import '../../models/family.dart';
import '../../models/family_category.dart';
import '../../models/family_detiles_model.dart';

class FamilyCubit extends Cubit<FamilyState> {
  final DioConsumer api;
  FamilyCubit({required this.api}) : super(FamilyInitial());

  static FamilyCubit get(context) => BlocProvider.of(context);

  List<Family> allFamilies = [];
  late int blockId;
  Person? selectedFamilyHead;
  FamilyCategory? selectedCategory;
  FamilyType? selectedFamilyType;
  late int familyId;

  void setFamilyId(int familyId) {
    this.familyId = familyId;
  }

  void setBlockId(int blockId) {
    this.blockId = blockId;
  }

  void changeSelectedFamilyCategory(FamilyCategory? selectedCategory) {
    this.selectedCategory = selectedCategory;
    emit(ChangeFamilyCategory());
  }

  void changeSelectedFamilyType(FamilyType? selectedFamilyType) {
    this.selectedFamilyType = selectedFamilyType;
    emit(ChangeFamilyType());
  }

  void changeSelectedFamilyHaed(Person? selectedFamilyHead) {
    this.selectedFamilyHead = selectedFamilyHead;
    emit(changeFamilyHead());
  }

  Future<void> addNewFamily(Family family) async {
    emit(FamilyInitial());
    try {
      final response = await api.post(
        ApiLink.addFamily,
        data: {
          "name": family.name,
          "familyCatgoryId": family.familyCatgoryId,
          "location": family.location,
          "familyTypeId": family.familyTypeId,
          "familyNotes": family.familyNotes,
          "blockId": family.blockId,
          "familyHeadId": family.familyHeadId,
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
    emit(FamilyLoading());
    try {
      final response = await api.update(
        '${ApiLink.updateFamily}/${family.id}',
        data: {
          "name": family.name,
          "familyCatgoryId": family.familyCatgoryId,
          "location": family.location,
          "familyTypeId": family.familyTypeId,
          "familyNotes": family.familyNotes,
          "blockId": family.blockId,
          "familyHeadId": family.familyHeadId,
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

  Future<void> addFamilyMember({
    required int familyId,
    required String firstName,
    required String secondName,
    required String thirdName,
    required String lastName,
    required String phoneNumber,
    required String identityNumber,
    required String? email,
    required DateTime dateOfBirth,
    required String gender,
    required String bloodType,
    required String identityType,
    required String maritalStatus,
    required String occupationStatus,
    required bool isWhatsapp,
    required bool isCall,
    String? job,
  }) async {
    emit(FamilyLoading());
    try {
      final response = await api.post(
        ApiLink.addFamilyMember,
        isFromData: true,
        data: {
          "FamilyId": familyId,
          "FirstName": firstName,
          "SecondName": secondName,
          "ThirdName": thirdName,
          "LastName": lastName,
          "PhoneNumber": phoneNumber,
          "IsWhatsapp": isWhatsapp,
          "IsContactNumber": isCall,
          "Email": email,
          "DateOfBirth": dateOfBirth.toIso8601String(),
          "Gender": gender,
          "BloodType": bloodType,
          "IdentityNumber": identityNumber,
          "IdentityType": identityType,
          "MaritalStatus": maritalStatus,
          "OccupationStatus": occupationStatus,
          "Job": job,
        },
      );

      if (response["isSuccess"]) {
        emit(
          FamilyMemberAddedSuccessfully(message: "تم إضافة عضو الأسرة بنجاح"),
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

  Future<void> addExistingPersonToFamily({
    required int familyId,
    required int personId,
    required int roleId,
  }) async {
    emit(FamilyLoading());
    try {
      final response = await api.post(
        ApiLink.addExistingPersonToFamily,
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
    emit(FamilyLoading());
    try {
      final response = await api.delete('${ApiLink.deleteFamily}/$id');

      if (response["isSuccess"]) {
        emit(FamilyDeletedSuccessfully(message: "تم حذف الأسرة بنجاح"));
        // await getFamilyDetilesById();
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
