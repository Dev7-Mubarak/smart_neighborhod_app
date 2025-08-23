import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Authorization"] =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBZG1pbiIsImp0aSI6IjZmNDZlN2M0LTgxOTQtNDJlZi1iZmY2LTg5YTgxM2ZjNGNiNyIsImVtYWlsIjoiYWRtaW5AZXhhbXBsZS5jb20iLCJ1aWQiOiJhYWFhYWFhYS1hYWFhLWFhYWEtYWFhYS1hYWFhYWFhYWFhYWEiLCJyb2xlcyI6IkFkbWluIiwiZXhwIjoxNzU2NTAyMTYyLCJpc3MiOiJTbWFydE5laWdoYm9yaG9vZEFQSSIsImF1ZCI6IlNtYXJ0TmVpZ2hib3Job29kV2ViQ2xpZW50In0.Y52neMevzsH9577MBqNSNmth4b1jDbpMEt98RzuSsdQ";
    super.onRequest(options, handler);
  }
}
