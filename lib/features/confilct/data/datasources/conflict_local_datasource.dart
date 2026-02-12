import '../dao/conflict_dao.dart';
import '../dao/conflict_type_dao.dart';
import '../models/conflict.dart';
import '../models/conflict_type.dart';

/// Local data source for conflicts
/// Wraps DAO operations and provides typed access to local database
class ConflictLocalDataSource {
  final ConflictDao _conflictDao;
  final ConflictTypeDao _conflictTypeDao;

  ConflictLocalDataSource({
    required ConflictDao conflictDao,
    required ConflictTypeDao conflictTypeDao,
  }) : _conflictDao = conflictDao,
       _conflictTypeDao = conflictTypeDao;

  // ============================================================================
  // CONFLICT OPERATIONS
  // ============================================================================

  /// Get all conflicts from local database
  Future<List<Conflict>> getAllConflicts() async {
    return await _conflictDao.getAll();
  }

  /// Get conflict by local ID
  Future<Conflict?> getConflictById(int id) async {
    return await _conflictDao.getById(id);
  }

  /// Get conflict by server ID
  Future<Conflict?> getConflictByServerId(int serverId) async {
    return await _conflictDao.getByServerId(serverId);
  }

  /// Insert new conflict into local database
  Future<int> insertConflict(Conflict conflict) async {
    return await _conflictDao.insert(conflict);
  }

  /// Update existing conflict in local database
  Future<int> updateConflict(Conflict conflict) async {
    return await _conflictDao.update(conflict);
  }

  /// Soft delete conflict (marks as deleted, doesn't remove from DB)
  Future<int> deleteConflict(int id) async {
    return await _conflictDao.softDelete(id);
  }

  /// Get conflicts pending synchronization
  Future<List<Conflict>> getPendingConflicts() async {
    return await _conflictDao.getPendingSync();
  }

  /// Mark conflict as synced with server
  Future<void> markConflictAsSynced(
    int localId, {
    required int serverId,
  }) async {
    await _conflictDao.markAsSynced(localId, serverId: serverId);
  }

  /// Upsert conflict from server (insert or update based on server_id)
  Future<void> upsertConflictFromServer(Map<String, dynamic> serverData) async {
    await _conflictDao.upsertFromServer(serverData);
  }

  /// Get conflicts by resolution status
  Future<List<Conflict>> getConflictsByStatus(bool isResolved) async {
    return await _conflictDao.getByResolutionStatus(isResolved);
  }

  /// Get conflicts by type
  Future<List<Conflict>> getConflictsByType(int conflictTypeId) async {
    return await _conflictDao.getByTypeId(conflictTypeId);
  }

  /// Get conflicts involving a specific person
  Future<List<Conflict>> getConflictsByPerson(int personId) async {
    return await _conflictDao.getByPersonId(personId);
  }

  /// Search conflicts
  Future<List<Conflict>> searchConflicts(String query) async {
    return await _conflictDao.search(query);
  }

  /// Get upcoming conflicts (future session dates)
  Future<List<Conflict>> getUpcomingConflicts() async {
    return await _conflictDao.getUpcoming();
  }

  /// Update conflict resolution status
  Future<int> updateConflictResolutionStatus(int id, bool isResolved) async {
    return await _conflictDao.updateResolutionStatus(id, isResolved);
  }

  // ============================================================================
  // CONFLICT TYPE OPERATIONS
  // ============================================================================

  /// Get all conflict types (for dropdowns)
  Future<List<ConflictType>> getAllConflictTypes() async {
    return await _conflictTypeDao.getAllActive();
  }

  /// Get conflict type by local ID
  Future<ConflictType?> getConflictTypeById(int id) async {
    return await _conflictTypeDao.getById(id);
  }

  /// Get conflict type by server ID
  Future<ConflictType?> getConflictTypeByServerId(int serverId) async {
    return await _conflictTypeDao.getByServerId(serverId);
  }

  /// Insert conflict type
  Future<int> insertConflictType(ConflictType type) async {
    return await _conflictTypeDao.insert(type);
  }

  /// Update conflict type
  Future<int> updateConflictType(ConflictType type) async {
    return await _conflictTypeDao.update(type);
  }

  /// Upsert conflict type from server
  Future<void> upsertConflictTypeFromServer(
    Map<String, dynamic> serverData,
  ) async {
    await _conflictTypeDao.upsertFromServer(serverData);
  }

  /// Search conflict types by name
  Future<List<ConflictType>> searchConflictTypes(String query) async {
    return await _conflictTypeDao.searchByName(query);
  }
}
