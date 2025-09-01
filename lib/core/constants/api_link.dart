class ApiLink {
  // Base
  static const String server = 'https://smartneighboorhood.runasp.net/api';

  // Auth
  static const String login = '$server/auth/login';
  static const String sendEmail = '$server/auth/reset-password/send-code';
  static const String sendConfirmationCode =
      '$server/auth/reset-password/verify-code';
  static const String sendNewPassword = '$server/auth/reset-password/confirm';

  // Blocks
  static const String getAllBlockes = '$server/blocks';
  static const String addBlocke = '$server/blocks';
  static const String updateBlocke = '$server/blocks';
  static const String deleteBlocke = '$server/blocks';
  static const String getBlockDetails = '$server/blocks/GetDetails';

  // Projects
  static const String getAllProjects = '$server/projects';
  static const String getAllProjectCatgories = '$server/projectCatgories';
  static const String addProject = '$server/projects';
  static const String updateProject = '$server/projects';
  static const String deleteProject = '$server/projects';
  static const String getProjectTeams = '$server/projects/GetProjectTeam';
  static const String getProjectBlockFamilies =
      '$server/projects/GetProjectBlocksWithBeneficiaryFamilies';
  static const String assignTeamToProject = '$server/projects/assign-team';
  static const String assignFamilyToProject = '$server/projects/assign-family';
  static const String removeTeamFromeProject = '$server/projects/remove-team';
  static const String removeFamilyFromeProject =
      '$server/projects/remove-family';

  // Teams
  static const String getAllTeams = '$server/projects/teams';
  static const String addTeam = '$server/projects/teams';
  static const String updateTeam = '$server/projects/teams';
  static const String deleteTeam = '$server/projects/teams';
  static const String getTeamById = '$server/projects/teams/GetById';
  static const String getProjectsByTeamId = '$server/projects/teams/by-team';
  static const String addTeamMember = '$server/projects/teams/members';
  static const String updateTeamMember = '$server/projects/teams/members';
  static const String deleteTeamMember = '$server/projects/teams/members';
  static const String getAllTeamRoles = '$server/projects/teams/roles';

  // Families
  static const String getAllFamilyCategories = '$server/familyCategories';
  static const String getAllMemberFamilyRoles =
      '$server/memberFamilyRoles/getAllMemberTypes';
  static const String getAllFamilyTypes = '$server/familyTypes';
  static const String addFamily = '$server/family';
  static const String deleteFamily = '$server/family';
  static const String getAllFamily = '$server/family';
  static const String updateFamily = '$server/family';
  static const String addFamilyMember = '$server/family/AddMember';
  static const String addExistingPersonToFamily = '$server/familyMembers';
  static const String getFamilyMembers = '$server/familyMembers';
  static const String getFamilyDetailes = '$server/family/GetDetailes';

  // Persons
  static const String addNewPerson = '$server/person';
  static const String deletePerson = '$server/person';
  static const String updatePerson = '$server/person';
  static const String getAllPepole = '$server/person';
  static const String getPersonById = '$server/person';

  // Conflict Cases
  static const String getAllConflict = '$server/conflictCase';
  static const String addConflict = '$server/conflictCase/Add';
  static const String updateConflict = '$server/conflictCase';
  static const String deleteConflict = '$server/conflictCase';
  static const String getAllConflictCaseTypes = '$server/conflictCaseType';
  static const String getConflictCasesByFamilyMember =
      '$server/conflictCase/ByFamilyMember';
}
