import 'package:shared_preferences/shared_preferences.dart';

class SessionLocal {
  static SharedPreferences? _prefs;
  static String sessionLocal = 'sessionLocal';

  static Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<String?> setSession(String session) async {
    await _init();
    await _prefs!.setString(sessionLocal, session);
    _prefs!.reload();
    return session;
  }

  static Future<String?> getSession() async {
    await _init();
    return _prefs!.getString(sessionLocal);
  }

  static Future<bool> clearSession() async {
    await _init();
    await _prefs!.remove(sessionLocal);
    return true;
  }
}
