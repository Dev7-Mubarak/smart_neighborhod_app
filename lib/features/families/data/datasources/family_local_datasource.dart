import 'package:smart_negborhood_app/database/database_service.dart';

import '../dao/family_dao.dart';
import '../dao/family_category_dao.dart';
import '../dao/family_member_role_dao.dart';
import '../dao/family_member_dao.dart';
import '../models/family.dart';
import '../models/family_category.dart';
import '../models/family_member_role.dart';

class FamilyLocalDataSource {
  final DatabaseService databaseService;
  late final FamilyDao familyDao;
  late final FamilyCategoryDao familyCategoryDao;
  late final FamilyMemberRoleDao familyMemberRoleDao;
  late final FamilyMemberDao familyMemberDao;

  FamilyLocalDataSource(this.databaseService) {
    familyDao = FamilyDao(databaseService);
    familyCategoryDao = FamilyCategoryDao(databaseService);
    familyMemberRoleDao = FamilyMemberRoleDao(databaseService);
    familyMemberDao = FamilyMemberDao(databaseService);
  }

  // Family Operations
  Future<int> insertFamily(Family family) async {
    return await familyDao.insert(family);
  }

  Future<int> updateFamily(Family family) async {
    return await familyDao.update(family);
  }

  Future<int> deleteFamily(int id) async {
    return await familyDao.softDelete(id);
  }

  Future<Family?> getFamilyById(int id) async {
    return await familyDao.getById(id);
  }

  Future<List<Family>> getAllFamilies() async {
    return await familyDao.getAll();
  }

  Future<List<Family>> getFamiliesByBlockId(int blockId) async {
    return await familyDao.getByBlockId(blockId);
  }

  Future<List<Family>> getFamiliesByCategoryId(int categoryId) async {
    return await familyDao.getByCategoryId(categoryId);
  }

  Future<List<Family>> getFamiliesByHeadId(int headId) async {
    return await familyDao.getByFamilyHeadId(headId);
  }

  Future<List<Family>> searchFamilies(String searchText) async {
    return await familyDao.searchByText(searchText);
  }

  Future<List<Family>> getPendingFamilies() async {
    return await familyDao.getPendingSync();
  }

  Future<void> markFamilyAsSynced(int id, {int? serverId}) async {
    await familyDao.markAsSynced(id, serverId: serverId);
  }

  Future<void> upsertFamilyFromServer(Family family) async {
    await familyDao.upsertFromServer(family.toMap());
  }

  Future<int> getPendingFamiliesCount() async {
    final pending = await getPendingFamilies();
    return pending.length;
  }

  // Family Category Operations
  Future<int> insertFamilyCategory(FamilyCategory category) async {
    return await familyCategoryDao.insert(category);
  }

  Future<int> updateFamilyCategory(FamilyCategory category) async {
    return await familyCategoryDao.update(category);
  }

  Future<FamilyCategory?> getFamilyCategoryById(int id) async {
    return await familyCategoryDao.getById(id);
  }

  Future<List<FamilyCategory>> getAllFamilyCategories() async {
    return await familyCategoryDao.getAll();
  }

  Future<List<FamilyCategory>> getActiveFamilyCategories() async {
    return await familyCategoryDao.getAllActive();
  }

  Future<List<FamilyCategory>> searchFamilyCategories(String searchText) async {
    return await familyCategoryDao.searchByName(searchText);
  }

  Future<void> upsertFamilyCategoryFromServer(FamilyCategory category) async {
    await familyCategoryDao.upsertFromServer(category.toMap());
  }

  // Family Member Role Operations
  Future<int> insertRole(Role role) async {
    return await familyMemberRoleDao.insert(role);
  }

  Future<int> updateRole(Role role) async {
    return await familyMemberRoleDao.update(role);
  }

  Future<Role?> getRoleById(int id) async {
    return await familyMemberRoleDao.getById(id);
  }

  Future<List<Role>> getAllRoles() async {
    return await familyMemberRoleDao.getAll();
  }

  Future<List<Role>> getActiveRoles() async {
    return await familyMemberRoleDao.getAllActive();
  }

  Future<List<Role>> searchRoles(String searchText) async {
    return await familyMemberRoleDao.searchByName(searchText);
  }

  Future<void> upsertRoleFromServer(Role role) async {
    await familyMemberRoleDao.upsertFromServer(role.toMap());
  }

  // Family Member Operations (Junction Table)
  Future<int> insertFamilyMember(FamilyMemberEntry member) async {
    return await familyMemberDao.insert(member);
  }

  Future<int> updateFamilyMember(FamilyMemberEntry member) async {
    return await familyMemberDao.update(member);
  }

  Future<int> deleteFamilyMember(int id) async {
    return await familyMemberDao.softDelete(id);
  }

  Future<FamilyMemberEntry?> getFamilyMemberById(int id) async {
    return await familyMemberDao.getById(id);
  }

  Future<List<FamilyMemberEntry>> getAllFamilyMembers() async {
    return await familyMemberDao.getAll();
  }

  Future<List<FamilyMemberEntry>> getFamilyMembersByFamilyId(
    int familyId,
  ) async {
    return await familyMemberDao.getByFamilyId(familyId);
  }

  Future<List<FamilyMemberEntry>> getFamilyMembersByPersonId(
    int personId,
  ) async {
    return await familyMemberDao.getByPersonId(personId);
  }

  Future<List<FamilyMemberEntry>> getFamilyMembersByRoleId(int roleId) async {
    return await familyMemberDao.getByRoleId(roleId);
  }

  Future<bool> isPersonMemberOfFamily(int familyId, int personId) async {
    return await familyMemberDao.isMemberOfFamily(familyId, personId);
  }

  Future<int> deleteFamilyMemberByFamilyAndPerson(
    int familyId,
    int personId,
  ) async {
    return await familyMemberDao.deleteByFamilyAndPerson(familyId, personId);
  }

  Future<void> markFamilyMemberAsSynced(int id, {int? serverId}) async {
    await familyMemberDao.markAsSynced(id, serverId: serverId);
  }

  Future<void> upsertFamilyMemberFromServer(FamilyMemberEntry member) async {
    await familyMemberDao.upsertFromServer(member.toMap());
  }
}
