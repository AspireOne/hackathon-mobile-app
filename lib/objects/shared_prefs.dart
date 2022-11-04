import 'package:shared_preferences/shared_preferences.dart';

class PrefsObject {
  // Obtain shared preferences.

  static void setToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();

    if (token == null) await prefs.remove("token");
    else await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}