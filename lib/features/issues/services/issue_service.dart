import '../data/dao/issue_dao.dart';
import '../data/models/issue.dart';

/// Service layer for Issue business logic and validation
class IssueService {
  final IssueDao _dao;

  IssueService({IssueDao? dao}) : _dao = dao ?? IssueDao();

  // Validation rules
  static const int minTitleLength = 5;
  static const int maxTitleLength = 200;
  static const int maxDescriptionLength = 2000;

  /// Create a new issue
  Future<IssueResult> createIssue({
    required String title,
    String? description,
    required IssueCategory category,
    IssuePriority priority = IssuePriority.medium,
    String? reporterId,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
  }) async {
    // Validate input
    final validationErrors = _validateIssueInput(
      title: title,
      description: description,
    );

    if (validationErrors.isNotEmpty) {
      return IssueResult.failure(validationErrors);
    }

    // Create issue
    final issue = Issue.create(
      title: title.trim(),
      description: description?.trim(),
      category: category,
      priority: priority,
      reporterId: reporterId,
      unitId: unitId,
      blockId: blockId,
      neighbourhoodId: neighbourhoodId,
    );

    try {
      await _dao.insert(issue);
      return IssueResult.success(issue);
    } catch (e) {
      return IssueResult.failure(['Failed to create issue: $e']);
    }
  }

  /// Update an existing issue
  Future<IssueResult> updateIssue(Issue issue) async {
    final validationErrors = _validateIssueInput(
      title: issue.title,
      description: issue.description,
    );

    if (validationErrors.isNotEmpty) {
      return IssueResult.failure(validationErrors);
    }

    final updatedIssue = issue.copyWith(updatedAt: DateTime.now());

    try {
      await _dao.update(updatedIssue);
      return IssueResult.success(updatedIssue);
    } catch (e) {
      return IssueResult.failure(['Failed to update issue: $e']);
    }
  }

  /// Update issue status
  Future<IssueResult> updateStatus(String id, IssueStatus newStatus) async {
    try {
      final issue = await _dao.getById(id);
      if (issue == null) {
        return IssueResult.failure(['Issue not found']);
      }

      final updatedIssue = issue.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
        resolvedAt: (newStatus == IssueStatus.resolved || newStatus == IssueStatus.closed)
            ? DateTime.now()
            : issue.resolvedAt,
      );

      await _dao.update(updatedIssue);
      return IssueResult.success(updatedIssue);
    } catch (e) {
      return IssueResult.failure(['Failed to update status: $e']);
    }
  }

  /// Assign issue to a user
  Future<IssueResult> assignIssue(String id, String assigneeId) async {
    try {
      final issue = await _dao.getById(id);
      if (issue == null) {
        return IssueResult.failure(['Issue not found']);
      }

      final updatedIssue = issue.copyWith(
        assignedTo: assigneeId,
        status: issue.status == IssueStatus.open 
            ? IssueStatus.inProgress 
            : issue.status,
        updatedAt: DateTime.now(),
      );

      await _dao.update(updatedIssue);
      return IssueResult.success(updatedIssue);
    } catch (e) {
      return IssueResult.failure(['Failed to assign issue: $e']);
    }
  }

  /// Resolve an issue with notes
  Future<IssueResult> resolveIssue(String id, String resolutionNotes) async {
    try {
      final issue = await _dao.getById(id);
      if (issue == null) {
        return IssueResult.failure(['Issue not found']);
      }

      final updatedIssue = issue.copyWith(
        status: IssueStatus.resolved,
        resolutionNotes: resolutionNotes.trim(),
        resolvedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _dao.update(updatedIssue);
      return IssueResult.success(updatedIssue);
    } catch (e) {
      return IssueResult.failure(['Failed to resolve issue: $e']);
    }
  }

  /// Delete an issue (soft delete)
  Future<IssueResult> deleteIssue(String id) async {
    try {
      final issue = await _dao.getById(id);
      if (issue == null) {
        return IssueResult.failure(['Issue not found']);
      }

      await _dao.softDelete(id);
      return IssueResult.success(issue.copyWith(deletedAt: DateTime.now()));
    } catch (e) {
      return IssueResult.failure(['Failed to delete issue: $e']);
    }
  }

  /// Get issue by ID
  Future<Issue?> getIssue(String id) async {
    return _dao.getById(id);
  }

  /// Get all issues
  Future<List<Issue>> getAllIssues() async {
    return _dao.getAll();
  }

  /// Get open issues
  Future<List<Issue>> getOpenIssues() async {
    return _dao.getOpenIssues();
  }

  /// Get resolved issues
  Future<List<Issue>> getResolvedIssues() async {
    return _dao.getResolvedIssues();
  }

  /// Get urgent issues (high/critical priority and open)
  Future<List<Issue>> getUrgentIssues() async {
    return _dao.getUrgentIssues();
  }

  /// Search issues
  Future<List<Issue>> searchIssues(String query) async {
    if (query.isEmpty) {
      return getAllIssues();
    }
    return _dao.searchIssues(query);
  }

  /// Get issues with filters and pagination
  Future<List<Issue>> getIssuesPaginated({
    required int page,
    int pageSize = 20,
    IssueStatus? status,
    IssuePriority? priority,
    IssueCategory? category,
    String? searchQuery,
  }) async {
    return _dao.getIssuesPaginated(
      page: page,
      pageSize: pageSize,
      status: status,
      priority: priority,
      category: category,
      searchQuery: searchQuery,
    );
  }

  /// Get issues by reporter
  Future<List<Issue>> getIssuesByReporter(String reporterId) async {
    return _dao.getByReporter(reporterId);
  }

  /// Get issues assigned to user
  Future<List<Issue>> getIssuesAssignedTo(String userId) async {
    return _dao.getAssignedTo(userId);
  }

  /// Get issues by unit
  Future<List<Issue>> getIssuesByUnit(String unitId) async {
    return _dao.getByUnit(unitId);
  }

  /// Get issues by block
  Future<List<Issue>> getIssuesByBlock(String blockId) async {
    return _dao.getByBlock(blockId);
  }

  /// Get pending sync count
  Future<int> getPendingSyncCount() async {
    return _dao.countPendingSync();
  }

  /// Get statistics
  Future<IssueStats> getStatistics() async {
    final all = await _dao.getAll();
    final byStatus = await _dao.countByStatus();
    final byPriority = await _dao.countByPriority();
    final byCategory = await _dao.countByCategory();
    final pendingSync = await _dao.countPendingSync();

    return IssueStats(
      total: all.length,
      open: byStatus[IssueStatus.open] ?? 0,
      inProgress: byStatus[IssueStatus.inProgress] ?? 0,
      resolved: byStatus[IssueStatus.resolved] ?? 0,
      closed: byStatus[IssueStatus.closed] ?? 0,
      critical: byPriority[IssuePriority.critical] ?? 0,
      high: byPriority[IssuePriority.high] ?? 0,
      byCategory: byCategory,
      pendingSync: pendingSync,
    );
  }

  /// Validate issue input
  List<String> _validateIssueInput({
    required String title,
    String? description,
  }) {
    final errors = <String>[];

    // Validate title
    if (title.trim().isEmpty) {
      errors.add('Title is required');
    } else if (title.trim().length < minTitleLength) {
      errors.add('Title must be at least $minTitleLength characters');
    } else if (title.trim().length > maxTitleLength) {
      errors.add('Title must be less than $maxTitleLength characters');
    }

    // Validate description (optional but if provided, check length)
    if (description != null && description.trim().length > maxDescriptionLength) {
      errors.add('Description must be less than $maxDescriptionLength characters');
    }

    return errors;
  }
}

/// Result wrapper for issue operations
class IssueResult {
  final bool isSuccess;
  final Issue? issue;
  final List<String> errors;

  IssueResult._({
    required this.isSuccess,
    this.issue,
    this.errors = const [],
  });

  factory IssueResult.success(Issue issue) {
    return IssueResult._(isSuccess: true, issue: issue);
  }

  factory IssueResult.failure(List<String> errors) {
    return IssueResult._(isSuccess: false, errors: errors);
  }

  String get errorMessage => errors.join(', ');
}

/// Statistics for issues
class IssueStats {
  final int total;
  final int open;
  final int inProgress;
  final int resolved;
  final int closed;
  final int critical;
  final int high;
  final Map<IssueCategory, int> byCategory;
  final int pendingSync;

  IssueStats({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.resolved,
    required this.closed,
    required this.critical,
    required this.high,
    required this.byCategory,
    required this.pendingSync,
  });

  int get activeCount => open + inProgress;
  int get urgentCount => critical + high;
}
