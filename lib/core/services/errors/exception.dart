import 'package:dio/dio.dart';

import 'errormodel.dart';

class Serverexception implements Exception {
  final ErrorModel errModel;
  Serverexception({required this.errModel});
}

void handleDioExceptions(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.cancel:
      throw Serverexception(
        errModel: ErrorModel(
          errorMessage: 'فشل الاتصال، يرجى التحقق من اتصالك بالإنترنت',
          statusCode: 500,
          isSuccess: false,
        ),
      );

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      throw Serverexception(
        errModel: ErrorModel(
          errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
          statusCode: 500,
          isSuccess: false,
        ),
      );

    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case 400:
        case 401:
        case 403:
        case 404:
        case 409:
        case 422:
        case 504:
          Map<String, dynamic> errData = {};
          if (error.response?.data is Map<String, dynamic>) {
            errData = error.response!.data;
          } else if (error.response?.data is String) {
            errData = {
              "statusCode": error.response?.statusCode,
              "message": error.response!.data,
              "isSuccess": false,
            };
          } else {
            errData = {
              "statusCode": error.response?.statusCode,
              "message": error.response?.statusMessage ?? 'خطأ غير معروف',
              "isSuccess": false,
            };
          }

          // Ensure statusCode is in the data so ErrorModel.fromJson doesn't crash on null
          errData["statusCode"] ??= error.response?.statusCode ?? 500;

          throw Serverexception(errModel: ErrorModel.fromJson(errData));
        default:
          throw Serverexception(
            errModel: ErrorModel(
              errorMessage: 'حدث خطأ من الخادم، يرجى المحاولة لاحقاً',
              statusCode: error.response?.statusCode ?? 500,
              isSuccess: false,
            ),
          );
      }
  }
}
