class ApiLink {
  // static const String server = 'https://localhost:7159/api';
  static const String server = 'https://smartneighboorhood.runasp.net/api';
  static const String login = '$server/Auth/Login';
  static const String getAllBlockes = '$server/Blocks/GetAll';
  static const String getAllProjects = '$server/Projects/GetAll';
  static const String getAllProjectCatgories =
      '$server/ProjectCatgories/GetAll';
  static const String deleteProject = '$server/Projects/Delete';
  static const String addProject = '$server/Projects/Add';
  static const String updateProject = '$server/Projects/Update';
  static const String getAllTeams = '$server/Teams/GetAll';
  static const String addTeam = '$server/Teams/Add';
  static const String updateTeam = '$server/Teams/Update';
  static const String deleteTeam = '$server/Teams/Delete';
  static const String getTeamById = '$server/Teams/GetById';
  static const String getProjectsByTeamId = '$server/Teams/by-team';
  static const String addTeamMember = '$server/TeamMembers/Add';
  static const String updateTeamMember = '$server/TeamMembers/Update';
  static const String deleteTeamMember = '$server/TeamMembers/Delete';
  static const String getAllTeamRoles = '$server/TeamRole/GetAll';

  static const String getAllFamilyCategories = '$server/FamilyCatgory/GetAll';
  static const String getAllMemberFamilyRoles =
      '$server/MemberFamilyRole/getAllMemberTypes';
  static const String getAllFamilyTypes = '$server/FamilyTypes/GetAll';
  static const String addBlocke = '$server/Blocks/Add';
  static const String updateBlocke = '$server/Blocks/Update';
  static const String deleteBlocke = '$server/Blocks/Delete';
  static const String addFamily = '$server/Family/Add';
  static const String deleteFamily = '$server/Family/Delete';
  static const String updateFamily = '$server/Family/Update';
  static const String addFamilyMember = '$server/Family/AddMember';
  static const String addExistingPersonToFamily = '$server/FamilyMembers/Add';
  static const String getFamilyDetailes = '$server/Family/GetDetailes';
  static const String getBlockDetails = '$server/Blocks/GetDetails';
  static const String addNewPerson = '$server/Person/Add';
  static const String deletePerson = '$server/Person/Delete';
  static const String updatePerson = '$server/Person/Update';
  static const String getAllPepole = '$server/Person/GetAll';
  static const String getPersonById = '$server/Person/GetById';
}
