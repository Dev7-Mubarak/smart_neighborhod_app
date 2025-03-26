class ErrorModel {
  final int status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    var errors = jsonData["errors"];
    String finalErrorMessage;

    if (errors != null && errors.isNotEmpty) {
      finalErrorMessage = errors[0]["errorMessage"];
    } else {
      finalErrorMessage = jsonData["message"];
    }

    return ErrorModel(
      status: jsonData["statusCode"],
      errorMessage: finalErrorMessage,
    );
  }
}
