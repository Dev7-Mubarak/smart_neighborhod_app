import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_negborhood_app/features/confilct/data/models/conflict.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../data/repositories/conflict_repository.dart';
import 'conflict_state.dart';

class ConflictCubit extends Cubit<ConflictState> {
  ConflictCubit({required this.repository}) : super(ConflictInitial());

  static ConflictCubit get(context) => BlocProvider.of(context);

  final ConflictRepository repository;

  Conflict? conflict;
  int? selectedfirstPartId;
  int? selectedSecondPartId;
  int? selectedConflictTypeId;
  DateTime? sessionDate;
  bool? isResolved;
  XFile? conflictPicture;
  List<Conflict> _allconflicts = [];

  /// Get all conflicts from local database (offline-first)
  Future<void> getAllConflicts({String? search}) async {
    emit(ConflictLoading());
    try {
      _allconflicts = await repository.getAllConflicts();

      if (search != null && search.isNotEmpty) {
        filterTeams(search);
      } else {
        if (!isClosed) {
          emit(
            ConflictLoaded(
              filteredConflicts: _allconflicts,
              allConflicts: _allconflicts,
            ),
          );
        }
      }
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
  }

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

  /// Add new conflict (saves to local DB with sync status='pending')
  Future<void> addConflict(String notes, String title) async {
    emit(WiateAddedUpdatedConflict());
    try {
      if (selectedConflictTypeId == null) {
        throw Exception("لا يمكن إضافة إتفاقية بدون تحديد نوع الإتفاقية");
      }
      if (selectedfirstPartId == null) {
        throw Exception("لا يمكن إضافة إتفاقية بدون تحديد الطرف الأول");
      }
      if (selectedSecondPartId == null) {
        throw Exception("لا يمكن إضافة إتفاقية بدون تحديد الطرف الثاني");
      }

      final profile = await SharedPreferencesService.getProfile();
      final managerName = profile?.identifier ?? 'Unknown';

      // Get conflict type name
      final conflictTypes = await repository.getAllConflictTypes();
      final conflictType = conflictTypes.firstWhere(
        (t) => t.id == selectedConflictTypeId,
        orElse: () => throw Exception('Conflict type not found'),
      );

      // Get party names (you may need to fetch from persons)
      // For now, using placeholders - implement person lookup if needed
      String firstPartyName = 'Party 1'; // TODO: Fetch from PersonRepository
      String secondPartyName = 'Party 2'; // TODO: Fetch from PersonRepository

      // Save to local database
      await repository.createConflict(
        conflictTypeId: selectedConflictTypeId!,
        conflictTypeName: conflictType.name,
        firstPartyId: selectedfirstPartId!,
        firstPartyName: firstPartyName,
        secondPartyId: selectedSecondPartId!,
        secondPartyName: secondPartyName,
        managerName: managerName,
        title: title,
        notes: notes,
        sessionDate: sessionDate,
        isResolved: isResolved ?? false,
        imagePath: conflictPicture?.path,
      );

      emit(
        ConflictAddedSuccessfully(
          message:
              "تمت الإضافة بنجاح. سيتم المزامنة عند الضغط على زر المزامنة.",
        ),
      );

      // Refresh the list
      await getAllConflicts();
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

  /// Update existing conflict (updates local DB with sync status='pending')
  Future<void> updateConflict({
    required int id,
    required String title,
    required String notes,
  }) async {
    emit(WiateAddedUpdatedConflict());
    try {
      if (selectedConflictTypeId == null) {
        throw Exception("لا يمكن إضافة إتفاقية بدون تحديد نوع الإتفاقية");
      }
      if (selectedfirstPartId == null) {
        throw Exception("لا يمكن إضافة إتفاقية بدون تحديد الطرف الأول");
      }
      if (selectedSecondPartId == null) {
        throw Exception("لا يمكن إضافة إتفاقية بدون تحديد الطرف الثاني");
      }

      final profile = await SharedPreferencesService.getProfile();
      final managerName = profile?.identifier ?? 'Unknown';

      // Get conflict type name
      final conflictTypes = await repository.getAllConflictTypes();
      final conflictType = conflictTypes.firstWhere(
        (t) => t.id == selectedConflictTypeId,
        orElse: () => throw Exception('Conflict type not found'),
      );

      // Get party names (placeholders for now)
      String firstPartyName = 'Party 1'; // TODO: Fetch from PersonRepository
      String secondPartyName = 'Party 2'; // TODO: Fetch from PersonRepository

      // Update in local database
      await repository.updateConflict(
        id: id,
        conflictTypeId: selectedConflictTypeId!,
        conflictTypeName: conflictType.name,
        firstPartyId: selectedfirstPartId!,
        firstPartyName: firstPartyName,
        secondPartyId: selectedSecondPartId!,
        secondPartyName: secondPartyName,
        managerName: managerName,
        title: title,
        notes: notes,
        sessionDate: sessionDate,
        isResolved: isResolved,
        imagePath: conflictPicture?.path,
      );

      emit(
        ConflictUpdatedSuccessfully(
          message: "تم التحديث بنجاح. سيتم المزامنة عند الضغط على زر المزامنة.",
        ),
      );

      // Refresh the list
      await getAllConflicts();
    } catch (e) {
      emit(ConflictFailure(errorMessage: e.toString()));
    }
  }

  /// Delete conflict (soft delete in local DB)
  Future<void> deleteConflict(int id) async {
    emit(WiateDeleteConflict());
    try {
      await repository.deleteConflict(id);

      emit(
        ConfllictDeletedSuccessfully(
          message: "تم الحذف بنجاح. سيتم المزامنة عند الضغط على زر المزامنة.",
        ),
      );

      await getAllConflicts();
    } catch (e) {
      emit(DeleteConflictFailure(errorMessage: e.toString()));
    }
  }

  /// Sync conflicts with server (manual trigger)
  Future<void> syncConflicts() async {
    emit(ConflictLoading());
    try {
      final result = await repository.syncConflicts();

      if (result.success) {
        emit(ConflictAddedSuccessfully(message: result.message));
      } else {
        emit(ConflictFailure(errorMessage: result.message));
      }

      // Refresh the list after sync
      await getAllConflicts();
    } catch (e) {
      emit(ConflictFailure(errorMessage: 'فشلت المزامنة: ${e.toString()}'));
    }
  }

  /// Get count of pending conflicts (for UI badge)
  Future<int> getPendingCount() async {
    try {
      return await repository.getPendingCount();
    } catch (e) {
      return 0;
    }
  }
}
