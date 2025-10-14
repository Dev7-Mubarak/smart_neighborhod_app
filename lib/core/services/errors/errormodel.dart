class ErrorModel {
  final num statusCode;
  final String errorMessage;
  final bool isSuccess;

  ErrorModel({
    required this.statusCode,
    required this.errorMessage,
    required this.isSuccess,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    var errors = jsonData["errors"];
    String finalErrorMessage;
    bool successStatus = jsonData["isSuccess"] ?? false;

    if (errors != null && errors.isNotEmpty) {
      finalErrorMessage = errors[0]["errorMessage"] ?? "خطأ غير معروف";
    } else {
      finalErrorMessage = jsonData["message"] ?? "خطأ غير معروف حدث.";
    }

    return ErrorModel(
      statusCode: jsonData["statusCode"] as num,
      errorMessage: finalErrorMessage,
      isSuccess: successStatus,
    );
  }
}
