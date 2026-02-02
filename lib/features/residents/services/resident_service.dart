import '../data/dao/resident_dao.dart';
import '../data/models/resident.dart';

/// Service layer for Resident business logic and validation
/// Handles all business rules and data validation
class ResidentService {
  final ResidentDao _dao;

  ResidentService({ResidentDao? dao}) : _dao = dao ?? ResidentDao();

  // Validation rules
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int nationalIdLength = 10; // Adjust based on your country's format

  /// Create a new resident with validation
  Future<ResidentResult> createResident({
    required String nationalId,
    required String fullName,
    String? phone,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
  }) async {
    // Validate input
    final validationErrors = _validateResidentInput(
      nationalId: nationalId,
      fullName: fullName,
      phone: phone,
    );

    if (validationErrors.isNotEmpty) {
      return ResidentResult.failure(validationErrors);
    }

    // Check for duplicate national ID
    final existingResident = await _dao.findByNationalId(nationalId);
    if (existingResident != null) {
      return ResidentResult.failure(['National ID already registered']);
    }

    // Create resident
    final resident = Resident.create(
      nationalId: nationalId.trim(),
      fullName: fullName.trim(),
      phone: phone?.trim(),
      unitId: unitId,
      blockId: blockId,
      neighbourhoodId: neighbourhoodId,
    );

    try {
      await _dao.insert(resident);
      return ResidentResult.success(resident);
    } catch (e) {
      return ResidentResult.failure(['Failed to save resident: $e']);
    }
  }

  /// Update an existing resident
  Future<ResidentResult> updateResident(Resident resident) async {
    final validationErrors = _validateResidentInput(
      nationalId: resident.nationalId,
      fullName: resident.fullName,
      phone: resident.phone,
    );

    if (validationErrors.isNotEmpty) {
      return ResidentResult.failure(validationErrors);
    }

    // Check for duplicate national ID (excluding current resident)
    if (await _dao.nationalIdExists(resident.nationalId, excludeId: resident.id)) {
      return ResidentResult.failure(['National ID already registered to another resident']);
    }

    final updatedResident = resident.copyWith(
      updatedAt: DateTime.now(),
    );

    try {
      await _dao.update(updatedResident);
      return ResidentResult.success(updatedResident);
    } catch (e) {
      return ResidentResult.failure(['Failed to update resident: $e']);
    }
  }

  /// Delete a resident (soft delete)
  Future<ResidentResult> deleteResident(String id) async {
    try {
      final resident = await _dao.getById(id);
      if (resident == null) {
        return ResidentResult.failure(['Resident not found']);
      }

      await _dao.softDelete(id);
      return ResidentResult.success(resident.copyWith(deletedAt: DateTime.now()));
    } catch (e) {
      return ResidentResult.failure(['Failed to delete resident: $e']);
    }
  }

  /// Get resident by ID
  Future<Resident?> getResident(String id) async {
    return _dao.getById(id);
  }

  /// Get all residents
  Future<List<Resident>> getAllResidents() async {
    return _dao.getAll();
  }

  /// Search residents by name or national ID
  Future<List<Resident>> searchResidents(String query) async {
    if (query.isEmpty) {
      return getAllResidents();
    }
    return _dao.searchByName(query);
  }

  /// Get residents by unit
  Future<List<Resident>> getResidentsByUnit(String unitId) async {
    return _dao.getByUnit(unitId);
  }

  /// Get residents by block
  Future<List<Resident>> getResidentsByBlock(String blockId) async {
    return _dao.getByBlock(blockId);
  }

  /// Get residents with pagination
  Future<List<Resident>> getResidentsPaginated({
    required int page,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    return _dao.getResidentsPaginated(
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
    );
  }

  /// Get count of pending sync residents
  Future<int> getPendingSyncCount() async {
    return _dao.countPendingSync();
  }

  /// Get residents pending sync
  Future<List<Resident>> getPendingSyncResidents() async {
    return _dao.getPendingSync();
  }

  /// Get statistics
  Future<ResidentStats> getStatistics() async {
    final all = await _dao.getAll();
    final pendingSync = await _dao.countPendingSync();
    final byStatus = await _dao.countByStatus();

    return ResidentStats(
      total: all.length,
      active: byStatus['active'] ?? 0,
      inactive: byStatus['inactive'] ?? 0,
      pendingSync: pendingSync,
    );
  }

  /// Validate resident input
  List<String> _validateResidentInput({
    required String nationalId,
    required String fullName,
    String? phone,
  }) {
    final errors = <String>[];

    // Validate national ID
    if (nationalId.trim().isEmpty) {
      errors.add('National ID is required');
    } else if (nationalId.trim().length != nationalIdLength) {
      errors.add('National ID must be $nationalIdLength characters');
    }

    // Validate name
    if (fullName.trim().isEmpty) {
      errors.add('Full name is required');
    } else if (fullName.trim().length < minNameLength) {
      errors.add('Name must be at least $minNameLength characters');
    } else if (fullName.trim().length > maxNameLength) {
      errors.add('Name must be less than $maxNameLength characters');
    }

    // Validate phone (optional but if provided, must be valid)
    if (phone != null && phone.trim().isNotEmpty) {
      if (!_isValidPhone(phone)) {
        errors.add('Invalid phone number format');
      }
    }

    return errors;
  }

  /// Simple phone validation
  bool _isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^\+?[0-9]{8,15}$').hasMatch(cleaned);
  }
}

/// Result wrapper for resident operations
class ResidentResult {
  final bool isSuccess;
  final Resident? resident;
  final List<String> errors;

  ResidentResult._({
    required this.isSuccess,
    this.resident,
    this.errors = const [],
  });

  factory ResidentResult.success(Resident resident) {
    return ResidentResult._(isSuccess: true, resident: resident);
  }

  factory ResidentResult.failure(List<String> errors) {
    return ResidentResult._(isSuccess: false, errors: errors);
  }

  String get errorMessage => errors.join(', ');
}

/// Statistics for residents
class ResidentStats {
  final int total;
  final int active;
  final int inactive;
  final int pendingSync;

  ResidentStats({
    required this.total,
    required this.active,
    required this.inactive,
    required this.pendingSync,
  });
}
