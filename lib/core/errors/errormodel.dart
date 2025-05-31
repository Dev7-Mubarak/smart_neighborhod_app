// class ErrorModel {
//   final String status;
//   final String errorMessage;

//   ErrorModel({required this.status, required this.errorMessage});

//   factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
//     var errors = jsonData["errors"];
//     String finalErrorMessage;

//     if (errors != null && errors.isNotEmpty) {
//       finalErrorMessage = errors[0]["errorMessage"];
//     } else {
//       finalErrorMessage = jsonData["message"];
//     }

//     return ErrorModel(
//       status: jsonData["statusCode"],
//       errorMessage: finalErrorMessage,
//     );
//   }
// }
class ErrorModel {
  final String statusCode; 
  final String errorMessage;
  final bool isSuccess; 

  ErrorModel({required this.statusCode, required this.errorMessage, required this.isSuccess});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    var errors = jsonData["errors"];
    String finalErrorMessage;
    bool successStatus = jsonData["isSuccess"] ?? false;

    if (errors != null && errors.isNotEmpty) {
      // إذا كانت الأخطاء قائمة، خذ رسالة الخطأ الأولى
      finalErrorMessage = errors[0]["errorMessage"] ?? "خطأ غير معروف";
    } else {
      // وإلا، خذ الرسالة العامة من الاستجابة
      finalErrorMessage = jsonData["message"] ?? "خطأ غير معروف حدث.";
    }

    return ErrorModel(
      statusCode: jsonData["statusCode"] as String, // تأكد من أنه String
      errorMessage: finalErrorMessage,
      isSuccess: successStatus,
    );
  }
}