import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../components/constants/api_link.dart';
import '../errors/exception.dart';
import 'APIConsumer.dart';
import 'api_interceptors.dart';
class dioConsumer extends ApiConsumer {
  final Dio dio;

  dioConsumer({required this.dio}) {
    //نضيف مع الdio أشياء أساسية ينضاف في أي ركوست نرسلة
    // إضافة الرابط الأساسي
    dio.options.baseUrl = ApiLink.server;

    // أضفت حارس المرور الذي أنشأته في الكلاس السابق
    dio.interceptors.add(ApiInterceptor());

    // هو رجل مرور زي ذاك ولكن هذا جاهز قده وظيفته يراقب الركوست الذاهب و الرسبونس و يطبع معلومات عنهم في الكونسيلر على حسب المعلومات إلي ني نحددها
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }
  @override
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

  @override
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

  @override
  Future? patch(
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

  @override
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
