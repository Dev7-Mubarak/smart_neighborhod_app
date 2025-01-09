import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_neighborhod_app/components/constants/api_link.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: ApiLink.server,
        receiveDataWhenStatusError: true,
        headers: {'Content-Type': 'application/json', 'lang': 'en'}));
  }

  static Future<Response> getData(
      {required String url, required Map<String, dynamic> query}) async {
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {required String url,
      required Map<String, dynamic> data,
      String? lang = 'en',
      String? token,
      Map<String, dynamic>? query}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token,
    };
    return await dio.post(url, queryParameters: query, data: data);
  }
}
