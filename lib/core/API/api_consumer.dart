abstract class ApiConsumer {
// في عنده مجموعة من الفنكشنز التي ليس لها بدي في كلاس الإبن بيسويلها أوفر رايت
  Future<dynamic> post(
    // برمتر ضروري يدخل
    String path,
//  برمترز إختيارية
    {
    Object? data,
    Map<String, dynamic>? queryparameters,
    // إذا مثلاً البيانات كان نوعها مش جيسون وإنما فورم نسوي ذا الخيار ترو
    bool isFromData = false,
  });
  Future<dynamic> get(
    // برمتر ضروري يدخل
    String path,
//  برمترز إختيارية
    {
    Object? data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  });
  Future<dynamic> delete(
    // برمتر ضروري يدخل
    String path,
//  برمترز إختيارية
    {
    Object? data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  });
  Future<dynamic>? patch(
    // برمتر ضروري يدخل
    String path,
//  برمترز إختيارية
    {
    Object? data,
    Map<String, dynamic>? queryparameters,
    bool isFromData = false,
  });
}
