class ApiLink {
  static const String server = 'https://smartnieborhoodapi.runasp.net';
  static const String login = '/api/Auth/Login';
  static const String getAllBlockes = '/api/Blocks/GetAll';
  static String getAllBlockFamilys(IdBlock) {
    return "block/get-familys/$IdBlock";
  }

  static String getAssistsFamily(IdFamily) {
    return "block/get-familys/$IdFamily";
  }
}
