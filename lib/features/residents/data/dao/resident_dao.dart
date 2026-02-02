import '../../../../core/database/dao/base_dao.dart';
import '../models/resident.dart';

/// Data Access Object for Resident records
/// Handles all local database operations for residents
class ResidentDao extends BaseDao<Resident> {
  ResidentDao() : super('residents');

  @override
  Map<String, dynamic> toMap(Resident item) => item.toMap();

  @override
  Resident fromMap(Map<String, dynamic> map) => Resident.fromMap(map);

  /// Search residents by name
  Future<List<Resident>> searchByName(String query) async {
    return search(
      where: 'full_name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'full_name ASC',
    );
  }

  /// Search residents by national ID
  Future<Resident?> findByNationalId(String nationalId) async {
    final results = await search(
      where: 'national_id = ?',
      whereArgs: [nationalId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Get residents by unit
  Future<List<Resident>> getByUnit(String unitId) async {
    return search(
      where: 'unit_id = ?',
      whereArgs: [unitId],
      orderBy: 'full_name ASC',
    );
  }

  /// Get residents by block
  Future<List<Resident>> getByBlock(String blockId) async {
    return search(
      where: 'block_id = ?',
      whereArgs: [blockId],
      orderBy: 'full_name ASC',
    );
  }

  /// Get residents by neighbourhood
  Future<List<Resident>> getByNeighbourhood(String neighbourhoodId) async {
    return search(
      where: 'neighbourhood_id = ?',
      whereArgs: [neighbourhoodId],
      orderBy: 'full_name ASC',
    );
  }

  /// Get active residents only
  Future<List<Resident>> getActiveResidents() async {
    return search(
      where: "status = 'active'",
      orderBy: 'full_name ASC',
    );
  }

  /// Get residents with pagination
  Future<List<Resident>> getResidentsPaginated({
    required int page,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    String? where;
    List<dynamic>? whereArgs;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where = 'full_name LIKE ? OR national_id LIKE ?';
      whereArgs = ['%$searchQuery%', '%$searchQuery%'];
    }

    return search(
      where: where,
      whereArgs: whereArgs,
      limit: pageSize,
      offset: page * pageSize,
      orderBy: 'full_name ASC',
    );
  }

  /// Count total residents
  Future<int> countAll() async {
    final db = await super.getAll();
    return db.length;
  }

  /// Count residents by status
  Future<Map<String, int>> countByStatus() async {
    final all = await getAll();
    final counts = <String, int>{};
    
    for (final resident in all) {
      counts[resident.status] = (counts[resident.status] ?? 0) + 1;
    }
    
    return counts;
  }

  /// Check if national ID exists (excluding specific resident)
  Future<bool> nationalIdExists(String nationalId, {String? excludeId}) async {
    final results = await search(
      where: excludeId != null
          ? 'national_id = ? AND id != ?'
          : 'national_id = ?',
      whereArgs: excludeId != null ? [nationalId, excludeId] : [nationalId],
      limit: 1,
    );
    return results.isNotEmpty;
  }
}
