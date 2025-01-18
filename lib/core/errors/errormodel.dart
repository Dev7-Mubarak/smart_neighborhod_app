// نسوي هنا مودل يعني إنه لما نستلم خطأ من الطلب خق ال API نطرحة في مودل عشان يتشكل ونقدر نعرضة للمستخدم

class ErrorModel{
  final int status;
  final String errorMessage;
  
  // هو عنده إتنين كونستركتر و إلي هم 
  //الكونستركتر العادي نستعمله لما بغيت بنشأ اوبجكت عادي من هذا المودل
  ErrorModel({required this.status,required this.errorMessage});

  // الكونستركتر الثاني نستعمله لما بغيت بحول الجيسون إلى مودل
  // نحول الجايسن إلي يجيلي و إلي هو خطأ إلى مودل 
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      status: jsonData["status"],
      errorMessage: jsonData["ErrorMessage"],
    );
  }
}
