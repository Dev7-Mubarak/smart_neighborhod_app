class ApiLink {
  // Base
  static const String server = 'https://smart-neighborhood-test.runasp.net/api';

  // Auth
  static const String login = '$server/auth/login';
  static const String sendEmail = '$server/auth/reset-password/send-code';
  static const String sendConfirmationCode =
      '$server/auth/reset-password/verify-code';
  static const String sendNewPassword = '$server/auth/reset-password/confirm';

  // Residentail Neighborhoods
  static const String getAllResidentialNeighborhoods =
      '$server/residential-neighborhoods';
  static const String getAllResidentialNeighborhoodsDashboard =
      '$server/residential-neighborhoods/dashboard';
  static const String addResidentialNeighborhood =
      '$server/residential-neighborhoods';
  static const String updateResidentialNeighborhood =
      '$server/residential-neighborhoods';
  static const String deleteResidentialNeighborhood =
      '$server/residential-neighborhoods';

  static String changeResidentialNeighborhoodManager({
    required int neighborhoodId,
  }) {
    return '$server/residential-neighborhoods/$neighborhoodId/manager';
  }

  static String getResidentialNeighborhoodUnits({required int neighborhoodId}) {
    return '$server/residential-neighborhoods/$neighborhoodId/units';
  }

  // Residential Units
  static const String getAllResidentialUnits = '$server/residential-units';
  static const String getAllResidentialUnitsDashboard =
      '$server/residential-units/dashboard';
  static const String addResidentialUnit = '$server/residential-units';
  static const String updateResidentialUnit = '$server/residential-units';
  static const String deleteResidentialUnit = '$server/residential-units';
  static String changeResidentialUnitsManager({required int unitId}) {
    return '$server/residential-units/$unitId/manager';
  }

  static String getResidentialUnitBlocks({required int unitId}) {
    return '$server/residential-units/$unitId/blocks';
  }

  // Residential Blocks
  static const String getAllResidentialBlocksDashboard =
      '$server/residential-blocks/dashboard';
  static const String addResidentialBlock = '$server/residential-blocks';
  static const String updateResidentialBlock = '$server/residential-blocks';
  static const String deleteResidentialBlock = '$server/residential-blocks';
  static String changeResidentialBlockManager({required int blockId}) {
    return '$server/residential-blocks/$blockId/manager';
  }

  static String getResidentialBlockFamilies({required int blockId}) {
    return '$server/residential-blocks/$blockId/families';
  }

  // Projects
  static const String getAllProjects = '$server/projects';
  static const String getAllProjectCatgories = '$server/project-categories';
  static const String addProject = '$server/projects';
  static const String updateProject = '$server/projects';
  static const String deleteProject = '$server/projects';
  static const String getProjectTeams = '$server/projects';
  static String getProjectBlockFamilies({required int projectId}) {
    return '$server/projects/$projectId/blocks-with-families';
  }

  static String assignTeamToProject({
    required int projectId,
    required int teamId,
  }) {
    return '$server/projects/$projectId/teams/$teamId';
  }

  static String assignFamilyToProject({
    required int projectId,
    required int familyId,
  }) {
    return '$server/projects/$projectId/families/$familyId';
  }

  static String removeTeamFromeProject({
    required int projectId,
    required int teamId,
  }) {
    return '$server/projects/$projectId/teams/$teamId';
  }

  static String removeFamilyFromeProject({
    required int projectId,
    required int familyId,
  }) {
    return '$server/projects/$projectId/families/$familyId';
  }

  // Teams
  static const String getAllTeams = '$server/teams';
  static const String addTeam = '$server/teams';
  static const String updateTeam = '$server/teams';
  static const String deleteTeam = '$server/teams';
  static const String getTeamById = '$server/teams';
  static String getProjectsByTeamId({required int teamId}) {
    return '$server/teams/$teamId/projects';
  }

  static const String addTeamMember = '$server/team-members';
  static const String updateTeamMember = '$server/team-members';
  static const String deleteTeamMember = '$server/team-members';
  static const String getAllTeamRoles = '$server/team-roles';

  // Families
  static const String getAllFamilyCategories = '$server/family-categories';
  static const String getAllMemberFamilyRoles = '$server/member-family-roles';
  // static const String getAllFamilyTypes = '$server/familyTypes';
  static const String addFamily = '$server/families';
  static const String deleteFamily = '$server/families';
  static const String getAllFamily = '$server/families';
  static const String updateFamily = '$server/families';
  static const String addFamilyMember = '$server/family-members';

  static const String getFamilyMembers = '$server/family-members';
  static const String getFamilyDetailes = '$server/families/details';

  // Persons
  static const String addNewPerson = '$server/person';
  static const String deletePerson = '$server/person';
  static const String updatePerson = '$server/person';
  static const String getAllPepole = '$server/person';
  static const String getPersonById = '$server/person';

  // Conflict Cases
  static const String getAllConflict = '$server/conflict-cases';
  static const String addConflict = '$server/conflict-cases';
  static const String updateConflict = '$server/conflict-cases';
  static const String deleteConflict = '$server/conflict-cases';
  static const String getAllConflictCaseTypes = '$server/conflict-case-type';
  static const String getConflictCasesByFamilyMember = '$server/conflict-cases';

  // Government Institutions
  static const String getAllGovernmentInstitutions =
      '$server/GovernmentInstitutions';
  static const String addGovernmentInstitution =
      '$server/GovernmentInstitutions';
  static const String updateGovernmentInstitution =
      '$server/GovernmentInstitutions';
  static const String deleteGovernmentInstitution =
      '$server/GovernmentInstitutions';

  static const String addGovernmentInstitutionContact =
      '$server/GovernmentInstitutionContacts/authority';
  static const String updateGovernmentInstitutionContact =
      '$server/GovernmentInstitutionContacts';
  static const String deleteGovernmentInstitutionContact =
      '$server/GovernmentInstitutionContacts';
}
