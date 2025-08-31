class ApiLink {
  static const String server = 'https://smartneighboorhood.runasp.net/api';
  static const String login = '$server/Auth/Login';
  static const String getAllBlockes = '$server/Blocks';
  static const String getAllProjects = '$server/Projects';
  static const String getAllProjectCatgories = '$server/ProjectCatgories';
  static const String deleteProject = '$server/Projects';
  static const String addProject = '$server/Projects';
  static const String updateProject = '$server/Projects';
  static const String getProjectTeams = '$server/Projects/GetProjectTeam';
  static const String getProjectBlockFamilies =
      '$server/Projects/GetProjectBlocksWithBeneficiaryFamilies';
  static const String assignTeamToProject = '$server/Projects/assign-team';
  static const String assignFamilyToProject = '$server/Projects/assign-family';
  static const String removeTeamFromeProject = '$server/Projects/remove-team';
  static const String removeFamilyFromeProject =
      '$server/Projects/remove-family';
  static const String getAllTeams = '$server/Teams';
  static const String addTeam = '$server/Teams';
  static const String updateTeam = '$server/Teams';
  static const String deleteTeam = '$server/Teams';
  static const String getTeamById = '$server/Teams/GetById';
  static const String getProjectsByTeamId = '$server/Teams/by-team';
  static const String addTeamMember = '$server/TeamMembers';
  static const String updateTeamMember = '$server/TeamMembers';
  static const String deleteTeamMember = '$server/TeamMembers';
  static const String getAllTeamRoles = '$server/TeamRole';

  static const String getAllFamilyCategories = '$server/FamilyCatgory';
  static const String getAllMemberFamilyRoles =
      '$server/MemberFamilyRole/getAllMemberTypes';
  static const String getAllFamilyTypes = '$server/FamilyTypes';
  static const String addBlocke = '$server/Blocks';
  static const String updateBlocke = '$server/Blocks';
  static const String deleteBlocke = '$server/Blocks';
  static const String addFamily = '$server/Family';
  static const String deleteFamily = '$server/Family';
  static const String getAllFamily = '$server/Family';
  static const String updateFamily = '$server/Family';
  static const String addFamilyMember = '$server/Family/AddMember';
  static const String addExistingPersonToFamily = '$server/FamilyMembers';
  static const String getFamilyMembers = '$server/FamilyMembers';
  static const String getFamilyDetailes = '$server/Family/GetDetailes';
  static const String getBlockDetails = '$server/Blocks/GetDetails';
  static const String addNewPerson = '$server/Person';
  static const String deletePerson = '$server/Person';
  static const String updatePerson = '$server/Person';
  static const String getAllPepole = '$server/Person';
  static const String getPersonById = '$server/Person/GetById';
  static const String getAllConflict = '$server/ConflictCase';
  static const String addConflict = '$server/ConflictCase/Add';
  static const String updateConflict = '$server/ConflictCase';
  static const String deleteConflict = '$server/ConflictCase';
  static const String getAllConfilctCaseTypes = '$server/ConfilctCaseType';
  static const String getConflictCasesByFamilyMember =
      '$server/ConflictCase/ByFamilyMember';

  static const String sendEmail = '$server/Auth/Password-reset/send-code';
  static const String sendConfirmationCode =
      '$server/Auth/Password-reset/verify-code';
  static const String sendNewPassword = '$server/Auth/Password-reset/confirm';
}
