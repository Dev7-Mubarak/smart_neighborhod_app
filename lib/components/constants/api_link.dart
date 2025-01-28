class ApiLink {
  static const String server = 'https://localhost:7060/api';
  static const String login = '/Auth/login';
  static const String getAllBlockes = '/';
  static String getAllBlockFamilys(IdBlock) {
    return "block/get-familys/$IdBlock";
  }
}
