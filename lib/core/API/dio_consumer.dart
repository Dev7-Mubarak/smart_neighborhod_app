import 'package:dio/dio.dart';
import '../../components/constants/api_link.dart';
import '../errors/exception.dart';
import 'api_consumer.dart';
import 'api_interceptors.dart';

class DioConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.interceptors.add(ApiInterceptor());

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.delete(path,
          data: isFromData ? FormData.fromMap(data) : data,
          queryParameters: queryparameters);
      return response.data;
    } on DioException catch (error) {
      handleDioExceptions(error);
    }
  }

  Future get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.get(path,
          data: isFromData ? FormData.fromMap(data) : data,
          queryParameters: queryparameters);
      return response.data;
    } on DioException catch (error) {
      handleDioExceptions(error);
    }
  }

  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.patch(path,
          data: isFromData ? FormData.fromMap(data) : data,
          queryParameters: queryparameters);
      return response.data;
    } on DioException catch (error) {
      handleDioExceptions(error);
    }
  }

  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  }) async {
    try {
      final response = await dio.post(path,
          data: isFromData ? FormData.fromMap(data) : data,
          queryParameters: queryparameters);
      return response.data;
    } on DioException catch (error) {
      handleDioExceptions(error);
    }
  }
}
