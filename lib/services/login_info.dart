import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSaver {
  static String nameKey = 'NAMEKEY';
  static String emailKey = 'EMAILKEY';
  static String imgKey = "IMAGEKEY";
  static String logKey = "LOGKEY";
  static String syncKey = 'SYNCKEY';

  static Future<bool> saveName(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nameKey, username);
  }

  static Future<bool> saveMail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailKey, userEmail);
  }

  static Future<bool> saveImg(String imgUrl) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(imgKey, imgUrl);
  }

  static Future<String?> getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(nameKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(emailKey);
  }

  static Future<String?> getImg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(imgKey);
  }

  static Future<bool> saveLoginData(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(logKey, isUserLoggedIn);
  }

  static Future<bool> saveSyncSet(bool isSyncOn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(syncKey, isSyncOn);
  }

  static Future<bool?> getLogData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(logKey);
  }

  static Future<bool?> getSyncSet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(syncKey);
  }
}
