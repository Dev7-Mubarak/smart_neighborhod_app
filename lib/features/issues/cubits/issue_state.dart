part of 'issue_cubit.dart';

/// Base state for issue management
abstract class IssueState extends Equatable {
  const IssueState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class IssueInitial extends IssueState {
  const IssueInitial();
}

/// Loading state
class IssueLoading extends IssueState {
  const IssueLoading();
}

/// Loaded state with issues list
class IssueLoaded extends IssueState {
  final List<Issue> issues;
  final IssueStats stats;
  final String? searchQuery;
  final IssueStatus? filterStatus;
  final IssuePriority? filterPriority;
  final IssueCategory? filterCategory;

  const IssueLoaded({
    required this.issues,
    required this.stats,
    this.searchQuery,
    this.filterStatus,
    this.filterPriority,
    this.filterCategory,
  });

  @override
  List<Object?> get props => [
        issues,
        stats,
        searchQuery,
        filterStatus,
        filterPriority,
        filterCategory,
      ];
}

/// Saving state
class IssueSaving extends IssueState {
  const IssueSaving();
}

/// Saved state
class IssueSaved extends IssueState {
  final Issue issue;
  final String message;

  const IssueSaved({required this.issue, required this.message});

  @override
  List<Object?> get props => [issue, message];
}

/// Deleted state
class IssueDeleted extends IssueState {
  final String message;

  const IssueDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class IssueError extends IssueState {
  final String message;

  const IssueError({required this.message});

  @override
  List<Object?> get props => [message];
}
