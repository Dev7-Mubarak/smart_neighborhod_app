class ApiLink {
  static const String server = 'https://smartnieborhoodapi.runasp.net/api';
  static const String login = '$server/Auth/Login';
  static const String getAllBlockes = '$server/api/Blocks/GetAll';

  static String getAllBlockFamilys(IdBlock) {
    return "block/get-familys/$IdBlock";
  }

  static String getAssistsFamily(IdFamily) {
    return "block/get-familys/$IdFamily";
  }
}
