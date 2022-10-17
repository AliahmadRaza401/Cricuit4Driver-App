import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class SharedPreferenceManager {

  static Future saveString(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String> getString(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(value);
  }


  static Future saveBoolean(String key, bool value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool(key, value);
  }

  static Future<bool> getBoolean(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey(key)) {
      return sharedPreferences.getBool(key);
    } else {
      return false;
    }
  }

  static Future removeKey(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }

}
