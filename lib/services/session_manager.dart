import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_LOGIN_STATE = "login_state";
  static const String KEY_USER_ID = "user_id";
  static const String KEY_USER_EMAIL = "user_email";

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> saveLoginSession({
    required String userId,
    required String email,
  }) async {
    final prefs = await _getPrefs();
    await prefs.setBool(KEY_LOGIN_STATE, true);
    await prefs.setString(KEY_USER_ID, userId);
    await prefs.setString(KEY_USER_EMAIL, email);
  }

  static Future<void> clearSession() async {
    final prefs = await _getPrefs();
    await prefs.remove(KEY_LOGIN_STATE);
    await prefs.remove(KEY_USER_ID);
    await prefs.remove(KEY_USER_EMAIL);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _getPrefs();
    return prefs.getBool(KEY_LOGIN_STATE) ?? false;
  }

  static Future<String?> getCurrentUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(KEY_USER_ID);
  }

  static Future<String?> getCurrentUserEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(KEY_USER_EMAIL);
  }
}
