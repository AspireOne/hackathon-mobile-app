import 'package:hackathon_app/objects/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsObject {
  static void setToken(String? token) async {
    var prefs = await SharedPreferences.getInstance();

    if (token == null) await prefs.remove("token");
    else await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<String>> getRecentProducts() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("recentProducts")?.toSet()?.toList() ?? [];
  }

  static void addRecentProduct(String id) async {
    var recentProducts = await getRecentProducts();
    if (recentProducts.contains(id)) return;
    recentProducts.add(id);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("recentProducts", recentProducts);
  }
}