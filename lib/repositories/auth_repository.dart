import '../models/user.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<User> login(String email, String password) async {
    final response = await _apiService.post(
      endpoint: '/login',
      data: {'email': email, 'password': password},
    );
    return User.fromJson(response);
  }
}
