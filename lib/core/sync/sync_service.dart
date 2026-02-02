import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database_service.dart';
import 'sync_models.dart';

/// Secure weekly sync service for offline-first architecture
/// Handles all data synchronization with the backend server
class SyncService {
  static SyncService? _instance;
  static SyncService get instance => _instance ??= SyncService._();
  
  SyncService._();
  
  final Dio _dio = Dio();
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  
  bool _isSyncing = false;
  final StreamController<SyncProgress> _progressController = 
      StreamController<SyncProgress>.broadcast();
  
  Stream<SyncProgress> get progressStream => _progressController.stream;
  bool get isSyncing => _isSyncing;
  
  // Sync configuration
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const String _authTokenKey = 'sync_auth_token';
  static const Duration syncInterval = Duration(days: 7);
  
  /// Check if sync is due (weekly)
  Future<bool> isSyncDue() async {
    final lastSync = await _secureStorage.read(key: _lastSyncKey);
    if (lastSync == null) return true;
    
    final lastSyncDate = DateTime.parse(lastSync);
    final now = DateTime.now();
    return now.difference(lastSyncDate) >= syncInterval;
  }
  
  /// Get time until next sync is due
  Future<Duration?> timeUntilNextSync() async {
    final lastSync = await _secureStorage.read(key: _lastSyncKey);
    if (lastSync == null) return null;
    
    final lastSyncDate = DateTime.parse(lastSync);
    final nextSyncDate = lastSyncDate.add(syncInterval);
    final now = DateTime.now();
    
    if (now.isAfter(nextSyncDate)) return Duration.zero;
    return nextSyncDate.difference(now);
  }
  
  /// Check network connectivity
  Future<bool> hasConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }
  
  /// Perform full weekly sync
  /// Returns SyncResult with details of the operation
  Future<SyncResult> performSync({
    required String baseUrl,
    String? authToken,
    void Function(SyncProgress)? onProgress,
  }) async {
    if (_isSyncing) {
      return SyncResult(
        status: SyncResultStatus.failed,
        errors: ['Sync already in progress'],
      );
    }
    
    // Check connectivity
    if (!await hasConnectivity()) {
      return SyncResult(
        status: SyncResultStatus.noConnection,
        errors: ['No internet connection available'],
      );
    }
    
    _isSyncing = true;
    final syncId = DateTime.now().millisecondsSinceEpoch.toString();
    final errors = <String>[];
    int uploadedCount = 0;
    int downloadedCount = 0;
    
    try {
      // Configure Dio with security settings
      await _configureDio(baseUrl, authToken);
      
      // Log sync start
      await _logSyncStart(syncId);
      
      _emitProgress(SyncProgress(
        stage: SyncStage.starting,
        message: 'Starting synchronization...',
      ));
      
      // Phase 1: Upload local changes
      _emitProgress(SyncProgress(
        stage: SyncStage.uploading,
        message: 'Uploading local changes...',
      ));
      
      final uploadResult = await _uploadPendingChanges();
      uploadedCount = uploadResult.count;
      errors.addAll(uploadResult.errors);
      
      // Phase 2: Download server changes
      _emitProgress(SyncProgress(
        stage: SyncStage.downloading,
        message: 'Downloading server updates...',
      ));
      
      final downloadResult = await _downloadServerChanges();
      downloadedCount = downloadResult.count;
      errors.addAll(downloadResult.errors);
      
      // Phase 3: Cleanup synced deletions
      _emitProgress(SyncProgress(
        stage: SyncStage.cleanup,
        message: 'Cleaning up...',
      ));
      
      await _cleanupSyncedDeletions();
      
      // Update last sync timestamp
      await _secureStorage.write(
        key: _lastSyncKey,
        value: DateTime.now().toIso8601String(),
      );
      
      // Log sync completion
      final status = errors.isEmpty 
          ? SyncResultStatus.success 
          : SyncResultStatus.partialSuccess;
      
      await _logSyncComplete(syncId, status, uploadedCount, downloadedCount, errors);
      
      _emitProgress(SyncProgress(
        stage: SyncStage.completed,
        message: 'Synchronization complete',
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
      ));
      
      return SyncResult(
        status: status,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        errors: errors,
      );
      
    } catch (e) {
      final error = 'Sync failed: ${e.toString()}';
      errors.add(error);
      
      await _logSyncComplete(
        syncId, 
        SyncResultStatus.failed, 
        uploadedCount, 
        downloadedCount, 
        errors,
      );
      
      _emitProgress(SyncProgress(
        stage: SyncStage.failed,
        message: error,
      ));
      
      return SyncResult(
        status: SyncResultStatus.failed,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        errors: errors,
      );
      
    } finally {
      _isSyncing = false;
    }
  }
  
  /// Configure Dio with secure settings
  Future<void> _configureDio(String baseUrl, String? authToken) async {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    );
    
    // Add certificate pinning for production
    // In production, implement certificate pinning here
  }
  
  /// Upload all pending local changes
  Future<_SyncPhaseResult> _uploadPendingChanges() async {
    final errors = <String>[];
    int count = 0;
    final db = await DatabaseService.instance.database;
    
    // Upload pending residents
    final pendingResidents = await db.query(
      'residents',
      where: "sync_status = 'pending'",
    );
    
    for (final resident in pendingResidents) {
      try {
        final isDeleted = resident['deleted_at'] != null;
        
        if (isDeleted) {
          // Sync deletion
          if (resident['server_id'] != null) {
            await _dio.delete('/api/residents/${resident['server_id']}');
          }
        } else if (resident['server_id'] != null) {
          // Update existing
          await _dio.put(
            '/api/residents/${resident['server_id']}',
            data: jsonEncode(_sanitizeForUpload(resident)),
          );
        } else {
          // Create new
          final response = await _dio.post(
            '/api/residents',
            data: jsonEncode(_sanitizeForUpload(resident)),
          );
          
          // Store server ID
          await db.update(
            'residents',
            {'server_id': response.data['id']},
            where: 'id = ?',
            whereArgs: [resident['id']],
          );
        }
        
        // Mark as synced
        await db.update(
          'residents',
          {'sync_status': 'synced'},
          where: 'id = ?',
          whereArgs: [resident['id']],
        );
        count++;
        
      } catch (e) {
        errors.add('Failed to sync resident ${resident['id']}: $e');
      }
    }
    
    // Upload pending issues
    final pendingIssues = await db.query(
      'issues',
      where: "sync_status = 'pending'",
    );
    
    for (final issue in pendingIssues) {
      try {
        final isDeleted = issue['deleted_at'] != null;
        
        if (isDeleted) {
          if (issue['server_id'] != null) {
            await _dio.delete('/api/issues/${issue['server_id']}');
          }
        } else if (issue['server_id'] != null) {
          await _dio.put(
            '/api/issues/${issue['server_id']}',
            data: jsonEncode(_sanitizeForUpload(issue)),
          );
        } else {
          final response = await _dio.post(
            '/api/issues',
            data: jsonEncode(_sanitizeForUpload(issue)),
          );
          
          await db.update(
            'issues',
            {'server_id': response.data['id']},
            where: 'id = ?',
            whereArgs: [issue['id']],
          );
        }
        
        await db.update(
          'issues',
          {'sync_status': 'synced'},
          where: 'id = ?',
          whereArgs: [issue['id']],
        );
        count++;
        
      } catch (e) {
        errors.add('Failed to sync issue ${issue['id']}: $e');
      }
    }
    
    return _SyncPhaseResult(count: count, errors: errors);
  }
  
  /// Download changes from server since last sync
  Future<_SyncPhaseResult> _downloadServerChanges() async {
    final errors = <String>[];
    int count = 0;
    final db = await DatabaseService.instance.database;
    
    final lastSync = await _secureStorage.read(key: _lastSyncKey);
    
    try {
      // Download residents updates
      final residentsResponse = await _dio.get(
        '/api/residents/changes',
        queryParameters: {
          if (lastSync != null) 'since': lastSync,
        },
      );
      
      if (residentsResponse.data['data'] != null) {
        for (final serverResident in residentsResponse.data['data']) {
          await _mergeServerRecord(db, 'residents', serverResident);
          count++;
        }
      }
      
    } catch (e) {
      errors.add('Failed to download residents: $e');
    }
    
    try {
      // Download issues updates
      final issuesResponse = await _dio.get(
        '/api/issues/changes',
        queryParameters: {
          if (lastSync != null) 'since': lastSync,
        },
      );
      
      if (issuesResponse.data['data'] != null) {
        for (final serverIssue in issuesResponse.data['data']) {
          await _mergeServerRecord(db, 'issues', serverIssue);
          count++;
        }
      }
      
    } catch (e) {
      errors.add('Failed to download issues: $e');
    }
    
    return _SyncPhaseResult(count: count, errors: errors);
  }
  
  /// Merge a server record into local database
  Future<void> _mergeServerRecord(
    dynamic db, 
    String table, 
    Map<String, dynamic> serverRecord,
  ) async {
    final serverId = serverRecord['id']?.toString();
    if (serverId == null) return;
    
    // Check if we have this record locally
    final localRecords = await db.query(
      table,
      where: 'server_id = ?',
      whereArgs: [serverId],
    );
    
    if (localRecords.isEmpty) {
      // New record from server - insert it
      serverRecord['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      serverRecord['server_id'] = serverId;
      serverRecord['sync_status'] = 'synced';
      
      await db.insert(table, _sanitizeForLocal(serverRecord));
    } else {
      // Existing record - check for conflicts
      final localRecord = localRecords.first;
      
      if (localRecord['sync_status'] == 'synced') {
        // No local changes, safe to overwrite
        serverRecord['id'] = localRecord['id'];
        serverRecord['server_id'] = serverId;
        serverRecord['sync_status'] = 'synced';
        
        await db.update(
          table,
          _sanitizeForLocal(serverRecord),
          where: 'id = ?',
          whereArgs: [localRecord['id']],
        );
      }
      // If local has pending changes, server changes are ignored (local wins)
      // This is a simple conflict resolution strategy
    }
  }
  
  /// Clean up records that have been synced and deleted
  Future<void> _cleanupSyncedDeletions() async {
    final db = await DatabaseService.instance.database;
    
    // Remove synced deletions older than 30 days
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    
    await db.delete(
      'residents',
      where: "sync_status = 'synced' AND deleted_at IS NOT NULL AND deleted_at < ?",
      whereArgs: [cutoff.toIso8601String()],
    );
    
    await db.delete(
      'issues',
      where: "sync_status = 'synced' AND deleted_at IS NOT NULL AND deleted_at < ?",
      whereArgs: [cutoff.toIso8601String()],
    );
  }
  
  /// Remove sync-related fields before upload
  Map<String, dynamic> _sanitizeForUpload(Map<String, dynamic> record) {
    final sanitized = Map<String, dynamic>.from(record);
    sanitized.remove('id');
    sanitized.remove('sync_status');
    sanitized.remove('server_id');
    return sanitized;
  }
  
  /// Prepare server record for local storage
  Map<String, dynamic> _sanitizeForLocal(Map<String, dynamic> record) {
    final sanitized = Map<String, dynamic>.from(record);
    // Remove any server-specific fields that don't match local schema
    return sanitized;
  }
  
  /// Log sync start
  Future<void> _logSyncStart(String syncId) async {
    final db = await DatabaseService.instance.database;
    await db.insert('sync_log', {
      'id': syncId,
      'sync_type': 'full',
      'started_at': DateTime.now().toIso8601String(),
      'status': 'in_progress',
    });
  }
  
  /// Log sync completion
  Future<void> _logSyncComplete(
    String syncId,
    SyncResultStatus status,
    int uploaded,
    int downloaded,
    List<String> errors,
  ) async {
    final db = await DatabaseService.instance.database;
    await db.update(
      'sync_log',
      {
        'completed_at': DateTime.now().toIso8601String(),
        'status': status.name,
        'records_uploaded': uploaded,
        'records_downloaded': downloaded,
        'error_message': errors.isNotEmpty ? errors.join('; ') : null,
      },
      where: 'id = ?',
      whereArgs: [syncId],
    );
  }
  
  /// Get sync history
  Future<List<SyncLog>> getSyncHistory({int limit = 10}) async {
    final db = await DatabaseService.instance.database;
    final results = await db.query(
      'sync_log',
      orderBy: 'started_at DESC',
      limit: limit,
    );
    
    return results.map((r) => SyncLog.fromMap(r)).toList();
  }
  
  /// Get last successful sync
  Future<SyncLog?> getLastSuccessfulSync() async {
    final db = await DatabaseService.instance.database;
    final results = await db.query(
      'sync_log',
      where: "status = 'success' OR status = 'partialSuccess'",
      orderBy: 'completed_at DESC',
      limit: 1,
    );
    
    if (results.isEmpty) return null;
    return SyncLog.fromMap(results.first);
  }
  
  void _emitProgress(SyncProgress progress) {
    _progressController.add(progress);
  }
  
  void dispose() {
    _progressController.close();
  }
}

/// Internal class for sync phase results
class _SyncPhaseResult {
  final int count;
  final List<String> errors;
  
  _SyncPhaseResult({required this.count, required this.errors});
}

/// Sync progress information
class SyncProgress {
  final SyncStage stage;
  final String message;
  final int? uploadedCount;
  final int? downloadedCount;
  final double? progress;
  
  SyncProgress({
    required this.stage,
    required this.message,
    this.uploadedCount,
    this.downloadedCount,
    this.progress,
  });
}

/// Sync stages
enum SyncStage {
  starting,
  uploading,
  downloading,
  cleanup,
  completed,
  failed,
}
