import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPrefernces;

  static init() async {
    sharedPrefernces = await SharedPreferences.getInstance();
  }

  static Future<bool> putData(
      {required String key, required bool value}) async {
    return await sharedPrefernces.setBool(key, value);
  }

  static bool? getData({required String key}) {
    return sharedPrefernces.getBool(key);
  }
}
