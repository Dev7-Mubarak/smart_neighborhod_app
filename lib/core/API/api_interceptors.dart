import 'package:dio/dio.dart';

//  وهذاالكلاس يحتوي على فنكشنات واجد نعملها وفر رايت كل وحد تعتبر زي حارس المرور على شي معيInterceptorعملت كلاس يورث من كلاس ال
class ApiInterceptor extends Interceptor{
  @override
 
//حارس المرور على كل ركوست تراقب كل ركوست وهو رايح بحيث ترسل شي معه
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Accepted_languge"] ="jdhnvj,njv";
        // CacheHelper().getData(key: ApiKey.token) != null
        //     ? 'FOODAPI ${CacheHelper().getData(key: ApiKey.token)}'
        //     : null;
    super.onRequest(options, handler);
  }
}
