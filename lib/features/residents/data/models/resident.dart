import 'package:equatable/equatable.dart';
import '../../../core/sync/sync_models.dart';

/// Resident model representing a neighbourhood resident
/// Supports offline-first CRUD with sync tracking
class Resident extends Equatable {
  final String id;
  final String nationalId;
  final String fullName;
  final String? phone;
  final String? unitId;
  final String? blockId;
  final String? neighbourhoodId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String? serverId;
  final DateTime? deletedAt;

  const Resident({
    required this.id,
    required this.nationalId,
    required this.fullName,
    this.phone,
    this.unitId,
    this.blockId,
    this.neighbourhoodId,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.serverId,
    this.deletedAt,
  });

  /// Create a new resident with generated ID
  factory Resident.create({
    required String nationalId,
    required String fullName,
    String? phone,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
    String status = 'active',
  }) {
    final now = DateTime.now();
    return Resident(
      id: '${now.millisecondsSinceEpoch}_${now.microsecond}',
      nationalId: nationalId,
      fullName: fullName,
      phone: phone,
      unitId: unitId,
      blockId: blockId,
      neighbourhoodId: neighbourhoodId,
      status: status,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );
  }

  /// Create copy with modifications
  Resident copyWith({
    String? id,
    String? nationalId,
    String? fullName,
    String? phone,
    String? unitId,
    String? blockId,
    String? neighbourhoodId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? serverId,
    DateTime? deletedAt,
  }) {
    return Resident(
      id: id ?? this.id,
      nationalId: nationalId ?? this.nationalId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      unitId: unitId ?? this.unitId,
      blockId: blockId ?? this.blockId,
      neighbourhoodId: neighbourhoodId ?? this.neighbourhoodId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'national_id': nationalId,
      'full_name': fullName,
      'phone': phone,
      'unit_id': unitId,
      'block_id': blockId,
      'neighbourhood_id': neighbourhoodId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'sync_status': syncStatus.value,
      'server_id': serverId,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Create from database map
  factory Resident.fromMap(Map<String, dynamic> map) {
    return Resident(
      id: map['id'] as String,
      nationalId: map['national_id'] as String,
      fullName: map['full_name'] as String,
      phone: map['phone'] as String?,
      unitId: map['unit_id'] as String?,
      blockId: map['block_id'] as String?,
      neighbourhoodId: map['neighbourhood_id'] as String?,
      status: map['status'] as String? ?? 'active',
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
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
      'nationalId': nationalId,
      'fullName': fullName,
      'phone': phone,
      'unitId': unitId,
      'blockId': blockId,
      'neighbourhoodId': neighbourhoodId,
      'status': status,
    };
  }

  /// Create from API JSON
  factory Resident.fromJson(Map<String, dynamic> json, {String? localId}) {
    final now = DateTime.now();
    return Resident(
      id: localId ?? '${now.millisecondsSinceEpoch}_${now.microsecond}',
      nationalId: json['nationalId'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      unitId: json['unitId'] as String?,
      blockId: json['blockId'] as String?,
      neighbourhoodId: json['neighbourhoodId'] as String?,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : now,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : now,
      syncStatus: SyncStatus.synced,
      serverId: json['id']?.toString(),
    );
  }

  bool get isSynced => syncStatus == SyncStatus.synced;
  bool get isPending => syncStatus == SyncStatus.pending;
  bool get isDeleted => deletedAt != null;

  @override
  List<Object?> get props => [
    id,
    nationalId,
    fullName,
    phone,
    unitId,
    blockId,
    neighbourhoodId,
    status,
    createdAt,
    updatedAt,
    syncStatus,
    serverId,
    deletedAt,
  ];
}
