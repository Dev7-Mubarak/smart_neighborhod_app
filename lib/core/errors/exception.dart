import 'package:dio/dio.dart';

import 'errormodel.dart';

// كلاس إنشأته عشان يتعامل مع إذا كان في خطأء من السرفر منعت وصول الركوست إليه
class Serverexception implements Exception {
  final ErrorModel errModel;
  Serverexception({required this.errModel});
}

void handleDioExceptions(DioException error) {
  switch (error.type) {
    // إذا صار خطأ من يعني الركوست ماوصلت إلى السرفر بسبب إنه السرفر فيه مشكله وهي سبع مشاكل من السرفر تؤذي إنه الركوست مايوصل إلى السرفر
    // 1
    case DioExceptionType.connectionTimeout:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));
    case DioExceptionType.sendTimeout:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));
    case DioExceptionType.receiveTimeout:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));
    case DioExceptionType.badCertificate:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));
    case DioExceptionType.cancel:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));
    case DioExceptionType.connectionError:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));
    case DioExceptionType.unknown:
      throw Serverexception(
          errModel: ErrorModel.fromJson(error.response!.data));

    //  هذا الخطأ الوحيد الذي ليس من السرفر و إنما من إنه وصل الركوست إلى السرفر ولكن في خطأ في البيانات المرسلة مثلاً الإيميل مكرر فيرجع خطأ
    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case 400: // Bad request
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
        case 401: //unauthorized
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
        case 403: //forbidden
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
        case 404: //not found
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
        case 409: //cofficient
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
        case 422: //  Unprocessable Entity
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
        case 504: // Server exception
          throw Serverexception(
              errModel: ErrorModel.fromJson(error.response!.data));
      }
      break;
  }
}
