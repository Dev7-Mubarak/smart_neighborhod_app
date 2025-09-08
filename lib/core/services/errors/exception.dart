import 'package:dio/dio.dart';

import 'errormodel.dart';

class Serverexception implements Exception {
  final ErrorModel errModel;
  Serverexception({required this.errModel});
}

void handleDioExceptions(DioException error) {
  switch (error.type) {
    // المجموعة الأولى: كل أخطاء الاتصال التي لا تحتوي على استجابة
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.cancel:
      throw Serverexception(
        errModel: ErrorModel(
          errorMessage: 'فشل الاتصال، يرجى التحقق من اتصالك بالإنترنت', statusCode: '', isSuccess: false,
        ),
      );
   
    // المجموعة الثانية: أخطاء أخرى غير متوقعة
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      throw Serverexception(
        errModel: ErrorModel(
          errorMessage: 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى', statusCode: '', isSuccess: false,
        ),
      );


    // المجموعة الثالثة: هنا فقط نكون متأكدين من وجود استجابة من الخادم
    case DioExceptionType.badResponse:
      // يمكنك ترك هذا الجزء كما هو لأنه يتعامل مع الحالات التي يوجد فيها استجابة بالفعل
      switch (error.response?.statusCode) {
        case 400: // Bad request
        case 401: // Unauthorized
        case 403: // Forbidden
        case 404: // Not found
        case 409: // Conflict
        case 422: // Unprocessable Entity
        case 504: // Server exception (Gateway Timeout)
          throw Serverexception(
            errModel: ErrorModel.fromJson(error.response!.data),
          );
        default:
          throw Serverexception(
            errModel: ErrorModel(
              errorMessage: 'حدث خطأ من الخادم، يرجى المحاولة لاحقاً', statusCode: '', isSuccess: false,
            ),
          );  
      }
  }
}

 // case DioExceptionType.connectionTimeout:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));
    // case DioExceptionType.sendTimeout:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));
    // case DioExceptionType.receiveTimeout:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));
    // case DioExceptionType.cancel:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));
    // case DioExceptionType.connectionError:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));

    // case DioExceptionType.badCertificate:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));      
    // case DioExceptionType.unknown:
    //   throw Serverexception(
    //       errModel: ErrorModel.fromJson(error.response!.data));
     
    // case DioExceptionType.badResponse:
    //   switch (error.response?.statusCode) {
    //     case 400: // Bad request
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //     case 401: //unauthorized
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //     case 403: //forbidden
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //     case 404: //not found
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //     case 409: //cofficient
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //     case 422: //  Unprocessable Entity
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //     case 504: // Server exception
    //       throw Serverexception(
    //           errModel: ErrorModel.fromJson(error.response!.data));
    //   } 