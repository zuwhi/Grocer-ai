import 'package:shared_preferences/shared_preferences.dart';

class LocalDateItems {
  static SharedPreferences? _prefs;
  static String localDateItems = 'LocalDateItems';

  static Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<String?> setLocalDateItems(String date) async {
    await _init();
    await _prefs!.setString(localDateItems, date);
    _prefs!.reload();
    return date;
  }

  static Future<String?> getLocalDateItems() async {
    await _init();
    return _prefs!.getString(localDateItems);
  }

  static Future<bool> clearLocalDateItemsn() async {
    await _init();
    await _prefs!.remove(localDateItems);
    return true;
  }
}
