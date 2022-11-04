import 'package:shared_preferences/shared_preferences.dart';

class PrefsObject {
  // Obtain shared preferences.

  static void setToken(String? token) async {
    SharedPreferences.getInstance().then((prefs) {
    if (token == null)
      prefs.remove("token");
    else
      prefs.setString('token', token);
    });
  }
}