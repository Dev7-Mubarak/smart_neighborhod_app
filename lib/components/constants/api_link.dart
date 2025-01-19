class ApiLink {
  static const String server = 'https://localhost:7060/api';
  static const String login = '/Auth/login';
  static String getUserDataEndPoint(id) {
    return "user/get-user/$id";
  }
}
