import 'package:dio/dio.dart';

import '../shared_preferences_service.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final profile = await SharedPreferencesService.getProfile();
    options.headers["Authorization"] = "Bearer ${profile?.token}";
    super.onRequest(options, handler);
  }
}

// {
//   "email": "sys.smartneighborhood@gmail.com",
//   "password": "Mub_12345"
// }
