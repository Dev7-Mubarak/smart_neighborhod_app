import 'package:dio/dio.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/services/errors/exception.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../models/conflict.dart';
import '../models/conflict_type.dart';

/// Remote data source for conflicts
/// Handles all API calls for conflicts and conflict types
class ConflictRemoteDataSource {
  final DioConsumer _api;

  ConflictRemoteDataSource({required DioConsumer api}) : _api = api;

  // ============================================================================
  // CONFLICT API OPERATIONS
  // ============================================================================

  /// Fetch all conflicts from server
  Future<List<Conflict>> getAllConflicts({String? search}) async {
    try {
      final response = await _api.get(
        ApiLink.getAllConflict,
        treat404AsEmptyList: true,
      );

      if (response["isSuccess"] != false) {
        List<dynamic> conflictsJson = response["data"];
        return conflictsJson.map((e) => Conflict.fromJson(e)).toList();
      }

      throw Serverexception(
        errModel: ErrorModel(
          statusCode: response["statusCode"] ?? '400',
          errorMessage: response["message"] ?? "Failed to fetch conflicts",
          isSuccess: false,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Create new conflict on server
  Future<Conflict> createConflict({
    required int conflictTypeId,
    required int firstPartyId,
    required int secondPartyId,
    required String title,
    required String notes,
    DateTime? sessionDate,
    bool isResolved = false,
    String? imagePath,
  }) async {
    try {
      final profile = await SharedPreferencesService.getProfile();
      final managerId = profile!.id;

      final response = await _api.post(
        ApiLink.addConflict,
        data: {
          "conflictTypeId": conflictTypeId,
          "managerId": managerId,
          "firstPartyId": firstPartyId,
          "secondPartyId": secondPartyId,
          "notes": notes,
          "title": title,
          "sessionDate": sessionDate?.toIso8601String(),
          "isResolved": isResolved,
          if (imagePath != null)
            "image": await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
        },
        isFromData: true,
      );

      if (response["isSuccess"]) {
        // Return the created conflict from response
        return Conflict.fromJson(response["data"]);
      }

      throw Serverexception(
        errModel: ErrorModel(
          statusCode: response["statusCode"] ?? '400',
          errorMessage: response["message"] ?? "Failed to create conflict",
          isSuccess: false,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update existing conflict on server
  Future<Conflict> updateConflict({
    required int id,
    required int conflictTypeId,
    required int firstPartyId,
    required int secondPartyId,
    required String title,
    required String notes,
    DateTime? sessionDate,
    bool? isResolved,
    String? imagePath,
  }) async {
    try {
      final profile = await SharedPreferencesService.getProfile();
      final managerId = profile!.id;

      final response = await _api.update(
        '${ApiLink.updateConflict}/$id',
        data: {
          "title": title,
          "conflictTypeId": conflictTypeId,
          "managerId": managerId,
          "firstPartyId": firstPartyId,
          "secondPartyId": secondPartyId,
          "notes": notes,
          "sessionDate": sessionDate?.toIso8601String(),
          "isResolved": isResolved,
          if (imagePath != null)
            "image": await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
        },
        isFromData: true,
      );

      if (response["isSuccess"]) {
        // Return the updated conflict from response
        return Conflict.fromJson(response["data"]);
      }

      throw Serverexception(
        errModel: ErrorModel(
          statusCode: response["statusCode"] ?? '400',
          errorMessage: response["message"] ?? "Failed to update conflict",
          isSuccess: false,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Delete conflict from server
  Future<void> deleteConflict(int id) async {
    try {
      final response = await _api.delete('${ApiLink.deleteConflict}/$id');

      if (!response["isSuccess"]) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: response["statusCode"] ?? '400',
            errorMessage: response["message"] ?? "Failed to delete conflict",
            isSuccess: false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================================
  // CONFLICT TYPE API OPERATIONS
  // ============================================================================

  /// Fetch all conflict types from server
  Future<List<ConflictType>> getAllConflictTypes() async {
    try {
      final response = await _api.get(
        ApiLink.getAllConflictCaseTypes,
        treat404AsEmptyList: true,
      );

      if (response["isSuccess"] != false) {
        List<dynamic> typesJson = response["data"];
        return typesJson.map((e) => ConflictType.fromJson(e)).toList();
      }

      throw Serverexception(
        errModel: ErrorModel(
          statusCode: response["statusCode"] ?? '400',
          errorMessage: response["message"] ?? "Failed to fetch conflict types",
          isSuccess: false,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
