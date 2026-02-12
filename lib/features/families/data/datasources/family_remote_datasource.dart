import '../../../../core/services/API/dio_consumer.dart';
import '../../../../core/constants/api_link.dart';
import '../../../../core/services/errors/exception.dart';
import '../../../../core/services/errors/errormodel.dart';
import '../models/family.dart';
import '../models/family_category.dart';
import '../models/family_member_role.dart';
import '../models/family_detiles_model.dart';

class FamilyRemoteDataSource {
  final DioConsumer api;

  FamilyRemoteDataSource(this.api);

  /// Upload a new family to the server
  Future<Map<String, dynamic>> createFamily(Family family) async {
    try {
      final response = await api.post(
        ApiLink.addFamily,
        data: family.toJson(family.familyHeadId),
      );

      if (response["isSuccess"]) {
        return response;
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "Failed to create family",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update an existing family on the server
  Future<Map<String, dynamic>> updateFamily(Family family) async {
    try {
      final id = family.serverId ?? family.id;
      final response = await api.update(
        '${ApiLink.updateFamily}/$id',
        data: family.toJson(family.familyHeadId),
      );

      if (response["isSuccess"]) {
        return response;
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "Failed to update family",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get all families from server
  Future<List<Family>> getAllFamilies() async {
    try {
      final response = await api.get(ApiLink.getAllFamily);

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> familiesJson = response["data"];
      return familiesJson.map((e) => Family.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get family details by ID
  Future<FamilyDetilesModel> getFamilyDetails(int id) async {
    try {
      final response = await api.get(
        ApiLink.getFamilyDetailes,
        queryparameters: {"id": id},
      );

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      return FamilyDetilesModel.fromJson(response["data"]);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete family from server
  Future<void> deleteFamily(int id) async {
    try {
      final response = await api.delete('${ApiLink.deleteFamily}/$id');

      if (!response["isSuccess"]) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: response["message"] ?? "Failed to delete family",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Add family member relationship
  Future<Map<String, dynamic>> addFamilyMember({
    required int familyId,
    required int personId,
    required int roleId,
  }) async {
    try {
      final response = await api.post(
        ApiLink.addFamilyMember,
        data: {"familyId": familyId, "personId": personId, "roleId": roleId},
      );

      if (response["isSuccess"]) {
        return response;
      } else {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: response["message"] ?? "Failed to add family member",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete family member relationship
  Future<void> deleteFamilyMember(int familyId, int familyMemberId) async {
    try {
      final response = await api.delete(
        '${ApiLink.getFamilyMembers}/$familyMemberId',
        queryparameters: {"familyId": familyId},
      );

      if (!response["isSuccess"]) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage:
                response["message"] ?? "Failed to delete family member",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get all family categories from server (lookup data)
  Future<List<FamilyCategory>> getAllFamilyCategories() async {
    try {
      final response = await api.get(ApiLink.getAllFamilyCategories);

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> categoriesJson = response["data"];
      return categoriesJson.map((e) => FamilyCategory.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all family member roles from server (lookup data)
  Future<List<Role>> getAllFamilyMemberRoles() async {
    try {
      final response = await api.get(ApiLink.getAllMemberFamilyRoles);

      if (response["data"] == null) {
        throw Serverexception(
          errModel: ErrorModel(
            statusCode: 400,
            errorMessage: "No data received",
            isSuccess: response["isSuccess"] ?? false,
          ),
        );
      }

      List<dynamic> rolesJson = response["data"];
      return rolesJson.map((e) => Role.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
