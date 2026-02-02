import '../../../../core/database/dao/base_dao.dart';
import '../models/issue.dart';

/// Data Access Object for Issue records
class IssueDao extends BaseDao<Issue> {
  IssueDao() : super('issues');

  @override
  Map<String, dynamic> toMap(Issue item) => item.toMap();

  @override
  Issue fromMap(Map<String, dynamic> map) => Issue.fromMap(map);

  /// Get issues by status
  Future<List<Issue>> getByStatus(IssueStatus status) async {
    return search(
      where: 'status = ?',
      whereArgs: [status.value],
      orderBy: 'created_at DESC',
    );
  }

  /// Get issues by priority
  Future<List<Issue>> getByPriority(IssuePriority priority) async {
    return search(
      where: 'priority = ?',
      whereArgs: [priority.value],
      orderBy: 'created_at DESC',
    );
  }

  /// Get issues by category
  Future<List<Issue>> getByCategory(IssueCategory category) async {
    return search(
      where: 'category = ?',
      whereArgs: [category.value],
      orderBy: 'created_at DESC',
    );
  }

  /// Get open issues
  Future<List<Issue>> getOpenIssues() async {
    return search(
      where: "status = 'open' OR status = 'in_progress'",
      orderBy: 'priority DESC, created_at DESC',
    );
  }

  /// Get resolved issues
  Future<List<Issue>> getResolvedIssues() async {
    return search(
      where: "status = 'resolved' OR status = 'closed'",
      orderBy: 'resolved_at DESC',
    );
  }

  /// Get issues by reporter
  Future<List<Issue>> getByReporter(String reporterId) async {
    return search(
      where: 'reporter_id = ?',
      whereArgs: [reporterId],
      orderBy: 'created_at DESC',
    );
  }

  /// Get issues assigned to user
  Future<List<Issue>> getAssignedTo(String userId) async {
    return search(
      where: 'assigned_to = ?',
      whereArgs: [userId],
      orderBy: 'priority DESC, created_at DESC',
    );
  }

  /// Get issues by unit
  Future<List<Issue>> getByUnit(String unitId) async {
    return search(
      where: 'unit_id = ?',
      whereArgs: [unitId],
      orderBy: 'created_at DESC',
    );
  }

  /// Get issues by block
  Future<List<Issue>> getByBlock(String blockId) async {
    return search(
      where: 'block_id = ?',
      whereArgs: [blockId],
      orderBy: 'created_at DESC',
    );
  }

  /// Get issues by neighbourhood
  Future<List<Issue>> getByNeighbourhood(String neighbourhoodId) async {
    return search(
      where: 'neighbourhood_id = ?',
      whereArgs: [neighbourhoodId],
      orderBy: 'created_at DESC',
    );
  }

  /// Search issues by title or description
  Future<List<Issue>> searchIssues(String query) async {
    return search(
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );
  }

  /// Get issues with pagination and filters
  Future<List<Issue>> getIssuesPaginated({
    required int page,
    int pageSize = 20,
    IssueStatus? status,
    IssuePriority? priority,
    IssueCategory? category,
    String? searchQuery,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (status != null) {
      conditions.add('status = ?');
      args.add(status.value);
    }

    if (priority != null) {
      conditions.add('priority = ?');
      args.add(priority.value);
    }

    if (category != null) {
      conditions.add('category = ?');
      args.add(category.value);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      conditions.add('(title LIKE ? OR description LIKE ?)');
      args.add('%$searchQuery%');
      args.add('%$searchQuery%');
    }

    return search(
      where: conditions.isNotEmpty ? conditions.join(' AND ') : null,
      whereArgs: args.isNotEmpty ? args : null,
      limit: pageSize,
      offset: page * pageSize,
      orderBy: 'priority DESC, created_at DESC',
    );
  }

  /// Count issues by status
  Future<Map<IssueStatus, int>> countByStatus() async {
    final all = await getAll();
    final counts = <IssueStatus, int>{};

    for (final issue in all) {
      counts[issue.status] = (counts[issue.status] ?? 0) + 1;
    }

    return counts;
  }

  /// Count issues by priority
  Future<Map<IssuePriority, int>> countByPriority() async {
    final all = await getAll();
    final counts = <IssuePriority, int>{};

    for (final issue in all) {
      counts[issue.priority] = (counts[issue.priority] ?? 0) + 1;
    }

    return counts;
  }

  /// Count issues by category
  Future<Map<IssueCategory, int>> countByCategory() async {
    final all = await getAll();
    final counts = <IssueCategory, int>{};

    for (final issue in all) {
      counts[issue.category] = (counts[issue.category] ?? 0) + 1;
    }

    return counts;
  }

  /// Get critical and high priority open issues
  Future<List<Issue>> getUrgentIssues() async {
    return search(
      where:
          "(priority = 'critical' OR priority = 'high') AND (status = 'open' OR status = 'in_progress')",
      orderBy: 'priority DESC, created_at ASC',
    );
  }
}
