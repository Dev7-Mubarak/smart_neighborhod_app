import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Authorization"] =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBZG1pbiIsImp0aSI6ImQyOTQwN2Q2LWNkMzctNDVlNC04ZDVjLWVlYTE0NmE5MTRhZCIsImVtYWlsIjoic3lzLnNtYXJ0bmVpZ2hib3Job29kQGdtYWlsLmNvbSIsInVpZCI6ImFhYWFhYWFhLWFhYWEtYWFhYS1hYWFhLWFhYWFhYWFhYWFhYSIsInJvbGVzIjoiQWRtaW4iLCJleHAiOjE3NTcxNTkyMDcsImlzcyI6IlNtYXJ0TmVpZ2hib3Job29kQVBJIiwiYXVkIjoiU21hcnROZWlnaGJvcmhvb2RXZWJDbGllbnQifQ.kwxQTQ4e1iOcwhzJHEPzmjg5gZJR8f_2FrFGT5hFZnk";
    super.onRequest(options, handler);
  }
}

// {
//   "email": "sys.smartneighborhood@gmail.com",
//   "password": "Mub_@12345"
// }
