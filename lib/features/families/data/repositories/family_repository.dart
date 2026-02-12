import 'package:flutter/foundation.dart';
import '../datasources/family_local_datasource.dart';
import '../datasources/family_remote_datasource.dart';
import '../models/family.dart';
import '../models/family_category.dart';
import '../models/family_member_role.dart';
import '../dao/family_member_dao.dart';

class SyncResult {
  final bool success;
  final int uploadedCount;
  final int downloadedCount;
  final List<String> errors;

  SyncResult({
    required this.success,
    this.uploadedCount = 0,
    this.downloadedCount = 0,
    this.errors = const [],
  });
}

class FamilyRepository {
  final FamilyLocalDataSource localDataSource;
  final FamilyRemoteDataSource remoteDataSource;

  FamilyRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // ==================== Family Operations ====================

  /// Get all families from local database
  Future<List<Family>> getAllFamilies() async {
    try {
      return await localDataSource.getAllFamilies();
    } catch (e) {
      debugPrint('Error getting all families: $e');
      return [];
    }
  }

  /// Get families by block ID from local database
  Future<List<Family>> getFamiliesByBlockId(int blockId) async {
    try {
      return await localDataSource.getFamiliesByBlockId(blockId);
    } catch (e) {
      debugPrint('Error getting families by block: $e');
      return [];
    }
  }

  /// Get families by category ID from local database
  Future<List<Family>> getFamiliesByCategoryId(int categoryId) async {
    try {
      return await localDataSource.getFamiliesByCategoryId(categoryId);
    } catch (e) {
      debugPrint('Error getting families by category: $e');
      return [];
    }
  }

  /// Search families in local database
  Future<List<Family>> searchFamilies(String query) async {
    try {
      return await localDataSource.searchFamilies(query);
    } catch (e) {
      debugPrint('Error searching families: $e');
      return [];
    }
  }

  /// Get family by ID from local database
  Future<Family?> getFamilyById(int id) async {
    try {
      return await localDataSource.getFamilyById(id);
    } catch (e) {
      debugPrint('Error getting family by ID: $e');
      return null;
    }
  }

  /// Create a new family (saves locally with pending status)
  Future<int?> createFamily(Family family) async {
    try {
      final now = DateTime.now();
      final familyToSave = family.copyWith(
        syncStatus: 'pending',
        createdAt: now,
        updatedAt: now,
      );
      return await localDataSource.insertFamily(familyToSave);
    } catch (e) {
      debugPrint('Error creating family: $e');
      return null;
    }
  }

  /// Update an existing family (saves locally with pending status)
  Future<bool> updateFamily(Family family) async {
    try {
      final familyToUpdate = family.copyWith(
        syncStatus: 'pending',
        updatedAt: DateTime.now(),
      );
      final rowsAffected = await localDataSource.updateFamily(familyToUpdate);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error updating family: $e');
      return false;
    }
  }

  /// Delete a family (marks as deleted locally)
  Future<bool> deleteFamily(int id) async {
    try {
      final family = await localDataSource.getFamilyById(id);
      if (family == null) return false;

      final deletedFamily = family.copyWith(
        syncStatus: 'pending',
        deletedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final rowsAffected = await localDataSource.updateFamily(deletedFamily);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error deleting family: $e');
      return false;
    }
  }

  /// Get count of pending families
  Future<int> getPendingFamiliesCount() async {
    try {
      return await localDataSource.getPendingFamiliesCount();
    } catch (e) {
      debugPrint('Error getting pending families count: $e');
      return 0;
    }
  }

  // ==================== Family Category Operations ====================

  /// Get all family categories from local database
  Future<List<FamilyCategory>> getAllCategories() async {
    try {
      return await localDataSource.getAllFamilyCategories();
    } catch (e) {
      debugPrint('Error getting all categories: $e');
      return [];
    }
  }

  /// Get active family categories
  Future<List<FamilyCategory>> getActiveCategories() async {
    try {
      return await localDataSource.getActiveFamilyCategories();
    } catch (e) {
      debugPrint('Error getting active categories: $e');
      return [];
    }
  }

  /// Sync family categories from server (refresh lookup data)
  Future<bool> syncCategories() async {
    try {
      final serverCategories = await remoteDataSource.getAllFamilyCategories();

      for (final category in serverCategories) {
        final categoryToSave = category.copyWith(
          syncStatus: 'synced',
          serverId: category.id,
          updatedAt: DateTime.now(),
        );
        await localDataSource.upsertFamilyCategoryFromServer(categoryToSave);
      }

      return true;
    } catch (e) {
      debugPrint('Error syncing categories: $e');
      return false;
    }
  }

  // ==================== Family Member Role Operations ====================

  /// Get all family member roles from local database
  Future<List<Role>> getAllRoles() async {
    try {
      return await localDataSource.getAllRoles();
    } catch (e) {
      debugPrint('Error getting all roles: $e');
      return [];
    }
  }

  /// Get active family member roles
  Future<List<Role>> getActiveRoles() async {
    try {
      return await localDataSource.getActiveRoles();
    } catch (e) {
      debugPrint('Error getting active roles: $e');
      return [];
    }
  }

  /// Sync family member roles from server (refresh lookup data)
  Future<bool> syncRoles() async {
    try {
      final serverRoles = await remoteDataSource.getAllFamilyMemberRoles();

      for (final role in serverRoles) {
        final roleToSave = role.copyWith(
          syncStatus: 'synced',
          serverId: role.id,
          updatedAt: DateTime.now(),
        );
        await localDataSource.upsertRoleFromServer(roleToSave);
      }

      return true;
    } catch (e) {
      debugPrint('Error syncing roles: $e');
      return false;
    }
  }

  // ==================== Family Member Operations (Junction Table) ====================

  /// Get all members of a specific family
  Future<List<FamilyMemberEntry>> getFamilyMembers(int familyId) async {
    try {
      return await localDataSource.getFamilyMembersByFamilyId(familyId);
    } catch (e) {
      debugPrint('Error getting family members: $e');
      return [];
    }
  }

  /// Get all families a person belongs to
  Future<List<FamilyMemberEntry>> getFamiliesForPerson(int personId) async {
    try {
      return await localDataSource.getFamilyMembersByPersonId(personId);
    } catch (e) {
      debugPrint('Error getting families for person: $e');
      return [];
    }
  }

  /// Add a person to a family with a specific role
  Future<int?> addFamilyMember({
    required int familyId,
    required int personId,
    required int roleId,
  }) async {
    try {
      final now = DateTime.now();
      final member = FamilyMemberEntry(
        id: 0, // Will be auto-generated
        familyId: familyId,
        personId: personId,
        roleId: roleId,
        syncStatus: 'pending',
        createdAt: now,
        updatedAt: now,
      );
      return await localDataSource.insertFamilyMember(member);
    } catch (e) {
      debugPrint('Error adding family member: $e');
      return null;
    }
  }

  /// Remove a person from a family
  Future<bool> removeFamilyMember(int familyId, int personId) async {
    try {
      final rowsAffected = await localDataSource
          .deleteFamilyMemberByFamilyAndPerson(familyId, personId);
      return rowsAffected > 0;
    } catch (e) {
      debugPrint('Error removing family member: $e');
      return false;
    }
  }

  /// Check if a person is member of a family
  Future<bool> isPersonMemberOfFamily(int familyId, int personId) async {
    try {
      return await localDataSource.isPersonMemberOfFamily(familyId, personId);
    } catch (e) {
      debugPrint('Error checking family membership: $e');
      return false;
    }
  }

  // ==================== Sync Operations ====================

  /// Sync all pending families with server (upload then download)
  Future<SyncResult> syncFamilies() async {
    int uploadedCount = 0;
    int downloadedCount = 0;
    List<String> errors = [];

    try {
      // Step 1: Upload pending families
      final pendingFamilies = await localDataSource.getPendingFamilies();

      for (final family in pendingFamilies) {
        try {
          if (family.deletedAt != null) {
            // Handle deletion
            if (family.serverId != null) {
              await remoteDataSource.deleteFamily(family.serverId!);
            }
            await localDataSource.deleteFamily(family.id);
          } else if (family.serverId == null) {
            // Create new family on server
            final response = await remoteDataSource.createFamily(family);
            final serverId = response['data']?['id'];

            if (serverId != null) {
              final syncedFamily = family.copyWith(
                serverId: serverId,
                syncStatus: 'synced',
                updatedAt: DateTime.now(),
              );
              await localDataSource.updateFamily(syncedFamily);
              uploadedCount++;
            }
          } else {
            // Update existing family on server
            await remoteDataSource.updateFamily(family);
            final syncedFamily = family.copyWith(
              syncStatus: 'synced',
              updatedAt: DateTime.now(),
            );
            await localDataSource.updateFamily(syncedFamily);
            uploadedCount++;
          }
        } catch (e) {
          errors.add('Failed to sync family ${family.name}: $e');
          debugPrint('Error syncing family ${family.id}: $e');
        }
      }

      // Step 2: Download all families from server
      try {
        final serverFamilies = await remoteDataSource.getAllFamilies();

        for (final serverFamily in serverFamilies) {
          try {
            final existingFamily = await localDataSource.getFamilyById(
              serverFamily.id,
            );

            final familyToSave = serverFamily.copyWith(
              syncStatus: 'synced',
              serverId: serverFamily.id,
              updatedAt: DateTime.now(),
            );

            if (existingFamily == null) {
              await localDataSource.insertFamily(familyToSave);
              downloadedCount++;
            } else if (existingFamily.syncStatus == 'synced') {
              // Only update if local copy is not pending changes
              await localDataSource.updateFamily(familyToSave);
              downloadedCount++;
            }
          } catch (e) {
            errors.add('Failed to save family ${serverFamily.name}: $e');
            debugPrint('Error saving family from server: $e');
          }
        }
      } catch (e) {
        errors.add('Failed to download families from server: $e');
        debugPrint('Error downloading families: $e');
      }

      return SyncResult(
        success: errors.isEmpty,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        errors: errors,
      );
    } catch (e) {
      debugPrint('Error in syncFamilies: $e');
      return SyncResult(
        success: false,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        errors: [...errors, 'Sync failed: $e'],
      );
    }
  }

  /// Sync all pending family members with server
  Future<SyncResult> syncFamilyMembers() async {
    int uploadedCount = 0;
    int downloadedCount = 0;
    List<String> errors = [];

    try {
      // Get all pending family member relationships
      final allMembers = await localDataSource.getAllFamilyMembers();
      final pendingMembers = allMembers
          .where((m) => m.syncStatus == 'pending')
          .toList();

      for (final member in pendingMembers) {
        try {
          if (member.deletedAt != null) {
            // Handle deletion
            if (member.serverId != null) {
              await remoteDataSource.deleteFamilyMember(
                member.familyId,
                member.serverId!,
              );
            }
            await localDataSource.deleteFamilyMember(member.id);
          } else {
            // Add new family member on server
            final response = await remoteDataSource.addFamilyMember(
              familyId: member.familyId,
              personId: member.personId,
              roleId: member.roleId ?? 0,
            );

            final serverId = response['data']?['id'];
            if (serverId != null) {
              final syncedMember = member.copyWith(
                serverId: serverId,
                syncStatus: 'synced',
                updatedAt: DateTime.now(),
              );
              await localDataSource.updateFamilyMember(syncedMember);
              uploadedCount++;
            }
          }
        } catch (e) {
          errors.add('Failed to sync family member ${member.id}: $e');
          debugPrint('Error syncing family member: $e');
        }
      }

      return SyncResult(
        success: errors.isEmpty,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        errors: errors,
      );
    } catch (e) {
      debugPrint('Error in syncFamilyMembers: $e');
      return SyncResult(
        success: false,
        uploadedCount: uploadedCount,
        downloadedCount: downloadedCount,
        errors: [...errors, 'Sync failed: $e'],
      );
    }
  }
}
