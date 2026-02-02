import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/issue.dart';
import '../services/issue_service.dart';

part 'issue_state.dart';

/// Cubit for managing issue UI state
class IssueCubit extends Cubit<IssueState> {
  final IssueService _service;

  IssueCubit({IssueService? service})
      : _service = service ?? IssueService(),
        super(const IssueInitial());

  /// Load all issues
  Future<void> loadIssues() async {
    emit(const IssueLoading());

    try {
      final issues = await _service.getAllIssues();
      final stats = await _service.getStatistics();
      emit(IssueLoaded(issues: issues, stats: stats));
    } catch (e) {
      emit(IssueError(message: 'Failed to load issues: $e'));
    }
  }

  /// Load open issues only
  Future<void> loadOpenIssues() async {
    emit(const IssueLoading());

    try {
      final issues = await _service.getOpenIssues();
      final stats = await _service.getStatistics();
      emit(IssueLoaded(issues: issues, stats: stats));
    } catch (e) {
      emit(IssueError(message: 'Failed to load issues: $e'));
    }
  }

  /// Load urgent issues
  Future<void> loadUrgentIssues() async {
    emit(const IssueLoading());

    try {
      final issues = await _service.getUrgentIssues();
      final stats = await _service.getStatistics();
      emit(IssueLoaded(issues: issues, stats: stats));
    } catch (e) {
      emit(IssueError(message: 'Failed to load issues: $e'));
    }
  }

  /// Search issues
  Future<void> searchIssues(String query) async {
    emit(const IssueLoading());

    try {
      final issues = await _service.searchIssues(query);
      final stats = await _service.getStatistics();
      emit(IssueLoaded(issues: issues, stats: stats, searchQuery: query));
    } catch (e) {
      emit(IssueError(message: 'Failed to search issues: $e'));
    }
  }

  /// Filter issues
  Future<void> filterIssues({
    IssueStatus? status,
    IssuePriority? priority,
    IssueCategory? category,
  }) async {
    emit(const IssueLoading());

    try {
      final issues = await _service.getIssuesPaginated(
        page: 0,
        pageSize: 100,
        status: status,
        priority: priority,
        category: category,
      );
      final stats = await _service.getStatistics();
      emit(IssueLoaded(
        issues: issues,
        stats: stats,
        filterStatus: status,
        filterPriority: priority,
        filterCategory: category,
      ));
    } catch (e) {
      emit(IssueError(message: 'Failed to filter issues: $e'));
    }
  }

  /// Create a new issue
  Future<void> createIssue({
    required String title,
    String? description,
    required IssueCategory category,
    IssuePriority priority = IssuePriority.medium,
    String? reporterId,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
  }) async {
    emit(const IssueSaving());

    final result = await _service.createIssue(
      title: title,
      description: description,
      category: category,
      priority: priority,
      reporterId: reporterId,
      unitId: unitId,
      blockId: blockId,
      neighbourhoodId: neighbourhoodId,
    );

    if (result.isSuccess) {
      emit(IssueSaved(issue: result.issue!, message: 'Issue created successfully'));
      await loadIssues();
    } else {
      emit(IssueError(message: result.errorMessage));
    }
  }

  /// Update an issue
  Future<void> updateIssue(Issue issue) async {
    emit(const IssueSaving());

    final result = await _service.updateIssue(issue);

    if (result.isSuccess) {
      emit(IssueSaved(issue: result.issue!, message: 'Issue updated successfully'));
      await loadIssues();
    } else {
      emit(IssueError(message: result.errorMessage));
    }
  }

  /// Update issue status
  Future<void> updateStatus(String id, IssueStatus newStatus) async {
    emit(const IssueSaving());

    final result = await _service.updateStatus(id, newStatus);

    if (result.isSuccess) {
      emit(IssueSaved(issue: result.issue!, message: 'Status updated'));
      await loadIssues();
    } else {
      emit(IssueError(message: result.errorMessage));
    }
  }

  /// Assign issue
  Future<void> assignIssue(String id, String assigneeId) async {
    emit(const IssueSaving());

    final result = await _service.assignIssue(id, assigneeId);

    if (result.isSuccess) {
      emit(IssueSaved(issue: result.issue!, message: 'Issue assigned'));
      await loadIssues();
    } else {
      emit(IssueError(message: result.errorMessage));
    }
  }

  /// Resolve issue
  Future<void> resolveIssue(String id, String resolutionNotes) async {
    emit(const IssueSaving());

    final result = await _service.resolveIssue(id, resolutionNotes);

    if (result.isSuccess) {
      emit(IssueSaved(issue: result.issue!, message: 'Issue resolved'));
      await loadIssues();
    } else {
      emit(IssueError(message: result.errorMessage));
    }
  }

  /// Delete issue
  Future<void> deleteIssue(String id) async {
    emit(const IssueSaving());

    final result = await _service.deleteIssue(id);

    if (result.isSuccess) {
      emit(const IssueDeleted(message: 'Issue deleted'));
      await loadIssues();
    } else {
      emit(IssueError(message: result.errorMessage));
    }
  }

  /// Get pending sync count
  Future<int> getPendingSyncCount() async {
    return _service.getPendingSyncCount();
  }
}
