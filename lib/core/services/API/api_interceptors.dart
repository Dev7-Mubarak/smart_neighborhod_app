import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers["Authorization"] = "Bearer";
    super.onRequest(options, handler);
  }
}

// {
//   "email": "sys.smartneighborhood@gmail.com",
//   "password": "Mub_@12345"
// }
