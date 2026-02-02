import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/resident.dart';
import '../services/resident_service.dart';

part 'resident_state.dart';

/// Cubit for managing resident UI state
/// Handles all resident-related UI operations
class ResidentCubit extends Cubit<ResidentState> {
  final ResidentService _service;

  ResidentCubit({ResidentService? service})
    : _service = service ?? ResidentService(),
      super(const ResidentInitial());

  /// Load all residents
  Future<void> loadResidents() async {
    emit(const ResidentLoading());

    try {
      final residents = await _service.getAllResidents();
      final stats = await _service.getStatistics();
      emit(ResidentLoaded(residents: residents, stats: stats));
    } catch (e) {
      emit(ResidentError(message: 'Failed to load residents: $e'));
    }
  }

  /// Search residents
  Future<void> searchResidents(String query) async {
    emit(const ResidentLoading());

    try {
      final residents = await _service.searchResidents(query);
      final stats = await _service.getStatistics();
      emit(
        ResidentLoaded(residents: residents, stats: stats, searchQuery: query),
      );
    } catch (e) {
      emit(ResidentError(message: 'Failed to search residents: $e'));
    }
  }

  /// Create a new resident
  Future<void> createResident({
    required String nationalId,
    required String fullName,
    String? phone,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
  }) async {
    emit(const ResidentSaving());

    final result = await _service.createResident(
      nationalId: nationalId,
      fullName: fullName,
      phone: phone,
      unitId: unitId,
      blockId: blockId,
      neighbourhoodId: neighbourhoodId,
    );

    if (result.isSuccess) {
      emit(
        ResidentSaved(
          resident: result.resident!,
          message: 'Resident created successfully',
        ),
      );
      // Reload the list
      await loadResidents();
    } else {
      emit(ResidentError(message: result.errorMessage));
    }
  }

  /// Update an existing resident
  Future<void> updateResident(Resident resident) async {
    emit(const ResidentSaving());

    final result = await _service.updateResident(resident);

    if (result.isSuccess) {
      emit(
        ResidentSaved(
          resident: result.resident!,
          message: 'Resident updated successfully',
        ),
      );
      // Reload the list
      await loadResidents();
    } else {
      emit(ResidentError(message: result.errorMessage));
    }
  }

  /// Delete a resident
  Future<void> deleteResident(String id) async {
    emit(const ResidentSaving());

    final result = await _service.deleteResident(id);

    if (result.isSuccess) {
      emit(const ResidentDeleted(message: 'Resident deleted successfully'));
      // Reload the list
      await loadResidents();
    } else {
      emit(ResidentError(message: result.errorMessage));
    }
  }

  /// Load residents by unit
  Future<void> loadResidentsByUnit(String unitId) async {
    emit(const ResidentLoading());

    try {
      final residents = await _service.getResidentsByUnit(unitId);
      final stats = await _service.getStatistics();
      emit(ResidentLoaded(residents: residents, stats: stats));
    } catch (e) {
      emit(ResidentError(message: 'Failed to load residents: $e'));
    }
  }

  /// Load residents by block
  Future<void> loadResidentsByBlock(String blockId) async {
    emit(const ResidentLoading());

    try {
      final residents = await _service.getResidentsByBlock(blockId);
      final stats = await _service.getStatistics();
      emit(ResidentLoaded(residents: residents, stats: stats));
    } catch (e) {
      emit(ResidentError(message: 'Failed to load residents: $e'));
    }
  }

  /// Get pending sync count
  Future<int> getPendingSyncCount() async {
    return _service.getPendingSyncCount();
  }
}
