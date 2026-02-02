import 'package:equatable/equatable.dart';
import '../../../core/sync/sync_models.dart';

/// Issue priority levels
enum IssuePriority {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  final String value;
  const IssuePriority(this.value);

  static IssuePriority fromString(String? value) {
    return IssuePriority.values.firstWhere(
      (e) => e.value == value,
      orElse: () => IssuePriority.medium,
    );
  }
}

/// Issue status
enum IssueStatus {
  open('open'),
  inProgress('in_progress'),
  resolved('resolved'),
  closed('closed');

  final String value;
  const IssueStatus(this.value);

  static IssueStatus fromString(String? value) {
    return IssueStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => IssueStatus.open,
    );
  }
}

/// Issue category
enum IssueCategory {
  maintenance('maintenance'),
  security('security'),
  noise('noise'),
  parking('parking'),
  cleanliness('cleanliness'),
  utilities('utilities'),
  other('other');

  final String value;
  const IssueCategory(this.value);

  static IssueCategory fromString(String? value) {
    return IssueCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => IssueCategory.other,
    );
  }
}

/// Issue model for tracking neighbourhood issues/complaints
class Issue extends Equatable {
  final String id;
  final String title;
  final String? description;
  final IssueCategory category;
  final IssuePriority priority;
  final IssueStatus status;
  final String? reporterId;
  final String? assignedTo;
  final String? unitId;
  final String? blockId;
  final String? neighbourhoodId;
  final String? resolutionNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final SyncStatus syncStatus;
  final String? serverId;
  final DateTime? deletedAt;

  const Issue({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.priority = IssuePriority.medium,
    this.status = IssueStatus.open,
    this.reporterId,
    this.assignedTo,
    this.unitId,
    this.blockId,
    this.neighbourhoodId,
    this.resolutionNotes,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.syncStatus = SyncStatus.pending,
    this.serverId,
    this.deletedAt,
  });

  /// Create a new issue with generated ID
  factory Issue.create({
    required String title,
    String? description,
    required IssueCategory category,
    IssuePriority priority = IssuePriority.medium,
    String? reporterId,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
  }) {
    final now = DateTime.now();
    return Issue(
      id: '${now.millisecondsSinceEpoch}_${now.microsecond}',
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: IssueStatus.open,
      reporterId: reporterId,
      unitId: unitId,
      blockId: blockId,
      neighbourhoodId: neighbourhoodId,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );
  }

  /// Create copy with modifications
  Issue copyWith({
    String? id,
    String? title,
    String? description,
    IssueCategory? category,
    IssuePriority? priority,
    IssueStatus? status,
    String? reporterId,
    String? assignedTo,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
    String? resolutionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? resolvedAt,
    SyncStatus? syncStatus,
    String? serverId,
    DateTime? deletedAt,
  }) {
    return Issue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      reporterId: reporterId ?? this.reporterId,
      assignedTo: assignedTo ?? this.assignedTo,
      unitId: unitId ?? this.unitId,
      blockId: blockId ?? this.blockId,
      neighbourhoodId: neighbourhoodId ?? this.neighbourhoodId,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.value,
      'priority': priority.value,
      'status': status.value,
      'reporter_id': reporterId,
      'assigned_to': assignedTo,
      'unit_id': unitId,
      'block_id': blockId,
      'neighbourhood_id': neighbourhoodId,
      'resolution_notes': resolutionNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'sync_status': syncStatus.value,
      'server_id': serverId,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Create from database map
  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: IssueCategory.fromString(map['category'] as String?),
      priority: IssuePriority.fromString(map['priority'] as String?),
      status: IssueStatus.fromString(map['status'] as String?),
      reporterId: map['reporter_id'] as String?,
      assignedTo: map['assigned_to'] as String?,
      unitId: map['unit_id'] as String?,
      blockId: map['block_id'] as String?,
      neighbourhoodId: map['neighbourhood_id'] as String?,
      resolutionNotes: map['resolution_notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      resolvedAt: map['resolved_at'] != null
          ? DateTime.parse(map['resolved_at'] as String)
          : null,
      syncStatus: SyncStatus.fromString(map['sync_status'] as String?),
      serverId: map['server_id'] as String?,
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category.value,
      'priority': priority.value,
      'status': status.value,
      'reporterId': reporterId,
      'assignedTo': assignedTo,
      'unitId': unitId,
      'blockId': blockId,
      'neighbourhoodId': neighbourhoodId,
      'resolutionNotes': resolutionNotes,
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  bool get isSynced => syncStatus == SyncStatus.synced;
  bool get isPending => syncStatus == SyncStatus.pending;
  bool get isDeleted => deletedAt != null;
  bool get isOpen => status == IssueStatus.open;
  bool get isResolved => status == IssueStatus.resolved || status == IssueStatus.closed;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        priority,
        status,
        reporterId,
        assignedTo,
        unitId,
        blockId,
        neighbourhoodId,
        resolutionNotes,
        createdAt,
        updatedAt,
        resolvedAt,
        syncStatus,
        serverId,
        deletedAt,
      ];
}
