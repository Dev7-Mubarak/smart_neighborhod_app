import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_negborhood_app/features/families/cubits/family_cubit/family_state.dart';
import 'package:smart_negborhood_app/features/families/data/models/family_member.dart';
import 'dart:async';
import '../../data/models/family.dart';
import '../../data/models/family_detiles_model.dart';
import '../../data/repositories/family_repository.dart';

class FamilyCubit extends Cubit<FamilyState> {
  final FamilyRepository repository;
  FamilyCubit({this.blockId, required this.repository})
    : super(FamilyInitial());

  static FamilyCubit get(context) => BlocProvider.of(context);

  List<Family> allFamilies = [];
  final int? blockId;
  int? selectedFamilyHeadId;
  HeadOfFamily? selectedFamilyHead;
  int? selectedCategoryId;
  Family? family;
  int? familyId;
  FamilyMember? familyMember;
  FamilyDetilesModel? _familyDetiles;
  List<FamilyMember> _allFamilyMembers = [];

  void setFamily(Family? family) {
    this.family = family;
  }

  void setFamilyForUpdate(Family family) {
    this.family = family;
    this.selectedCategoryId = family.familyCatgoryId;
    this.selectedFamilyHeadId = family.familyHeadId;
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
      final familyToCreate = family.copyWith(
        familyCatgoryId: this.selectedCategoryId ?? family.familyCatgoryId,
        familyHeadId: this.selectedFamilyHeadId ?? family.familyHeadId,
      );

      final familyId = await repository.createFamily(familyToCreate);

      if (familyId != null) {
        emit(FamilyAddedSuccessfully(message: "تم اضافة الاسرة بنجاح"));
        // Refresh local list
        await getAllFamilies();
      } else {
        emit(FamilyFailure(errorMessage: "فشل في حفظ الأسرة"));
      }
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> updateFamily(Family family) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final familyToUpdate = family.copyWith(
        familyCatgoryId: this.selectedCategoryId ?? family.familyCatgoryId,
        familyHeadId: this.selectedFamilyHeadId ?? family.familyHeadId,
      );

      final success = await repository.updateFamily(familyToUpdate);

      if (success) {
        emit(FamilyUpdatedSuccessfully(message: "تم تحديث الأسرة بنجاح"));
        // Refresh local list
        await getAllFamilies();
      } else {
        emit(FamilyFailure(errorMessage: "فشل في تحديث الأسرة"));
      }
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFamilyDetilesById(int id) async {
    familyId = id;
    emit(FamilyLoading());
    try {
      // Still using remote API for family details
      // TODO: Create a local query that joins families with members
      final response = await repository.remoteDataSource.getFamilyDetails(id);

      _familyDetiles = response;
      _allFamilyMembers = _familyDetiles!.familyMembers;

      if (!isClosed) {
        emit(
          FamilyDetilesLoaded(
            familyDetiles: _familyDetiles!,
            allFamilyMembers: _allFamilyMembers,
          ),
        );
      }
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  void filterFamilyMembers(String query) {
    if (_familyDetiles == null) return;

    if (query.isEmpty) {
      emit(
        FamilyDetilesLoaded(
          familyDetiles: _familyDetiles!,
          allFamilyMembers: _allFamilyMembers,
        ),
      );
      return;
    }
    final filteredList = _allFamilyMembers
        .where(
          (member) => member.person.fullName.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    emit(
      FamilyDetilesLoaded(
        familyDetiles: _familyDetiles!,
        allFamilyMembers: filteredList,
      ),
    );
  }

  Future<void> addFamilyMember({
    required int familyId,
    required int personId,
    required int roleId,
  }) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final memberId = await repository.addFamilyMember(
        familyId: familyId,
        personId: personId,
        roleId: roleId,
      );

      if (memberId != null) {
        emit(
          FamilyMemberAddedSuccessfully(message: "تم إضافة الشخص للأسرة بنجاح"),
        );
        // Optionally refresh family details
        if (this.familyId != null) {
          await getFamilyDetilesById(this.familyId!);
        }
      } else {
        emit(FamilyFailure(errorMessage: "فشل في إضافة عضو الأسرة"));
      }
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteFamily(int id) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final success = await repository.deleteFamily(id);

      if (success) {
        emit(FamilyDeletedSuccessfully(message: "تم حذف الأسرة بنجاح"));
        // Refresh local list
        await getAllFamilies();
      } else {
        emit(FamilyFailure(errorMessage: "فشل في حذف الأسرة"));
      }
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  /// Get all families from local database
  Future<void> getAllFamilies() async {
    emit(FamilyLoading());
    try {
      if (blockId != null) {
        allFamilies = await repository.getFamiliesByBlockId(blockId!);
      } else {
        allFamilies = await repository.getAllFamilies();
      }
      emit(FamilyLoaded(families: allFamilies));
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  Future<void> getFamiliesByBlockId() async {
    await getAllFamilies();
  }

  Future<void> deleteFamilyMember(int familyId, int personId) async {
    emit(WaitingForUpdateOrAddFamily());
    try {
      final success = await repository.removeFamilyMember(familyId, personId);

      if (success) {
        emit(
          FamilyMemberDeletedSuccessfully(message: "تم حذف فرد الأسرة بنجاح"),
        );
        // Optionally refresh family details
        if (this.familyId != null) {
          await getFamilyDetilesById(this.familyId!);
        }
      } else {
        emit(FamilyFailure(errorMessage: "فشل في حذف عضو الأسرة"));
      }
    } catch (e) {
      emit(FamilyFailure(errorMessage: e.toString()));
    }
  }

  /// Sync local families with server
  Future<void> syncFamilies() async {
    emit(FamilyLoading());
    try {
      final result = await repository.syncFamilies();
      await repository.syncFamilyMembers(); // Also sync members

      if (result.success) {
        // Refresh local list after sync
        await getAllFamilies();
        emit(
          FamilySyncedSuccessfully(
            message:
                "تم المزامنة بنجاح: ${result.uploadedCount} تم الرفع، ${result.downloadedCount} تم التنزيل",
          ),
        );
      } else {
        emit(
          FamilySyncFailed(
            errorMessage: "فشلت المزامنة: ${result.errors.join(', ')}",
          ),
        );
      }
    } catch (e) {
      emit(FamilySyncFailed(errorMessage: e.toString()));
    }
  }

  /// Get count of pending families
  Future<int> getPendingCount() async {
    try {
      return await repository.getPendingFamiliesCount();
    } catch (e) {
      return 0;
    }
  }
}
