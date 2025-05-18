class ApiLink {
  static const String server = 'https://localhost:7159/api';
  static const String login = '$server/Auth/Login';
  static const String getAllBlockes = '$server/Blocks/GetAll';
  static const String getAllFamilyCategories = '$server/FamilyCatgory/GetAll';
  static const String getAllFamilyTypes = '$server/FamilyTypes/GetAll';
  static const String addBlocke = '$server/Blocks/Add';
  static const String addFamily = '$server/Family/Add';
  static const String getFamilyDetilesById =
      '$server/Family/GetFamilyDetilesById';
  static const String getBlockFamiliesById =
      '$server/Blocks/GetBlockFamiliesById';
  static const String addNewPerson = '$server/Person/Add';
  static const String getAllPepole = '$server/Person/GetAll';

  static String getAllBlockFamilys(IdBlock) {
    return "block/get-familys/$IdBlock";
  }

  static String getAssistsFamily(IdFamily) {
    return "block/get-familys/$IdFamily";
  }
}
