import 'package:shared_preferences/shared_preferences.dart';

class PrefService {

  static Future<void> saveUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("email", email);
    await prefs.setString("password", password);
    await prefs.setBool("isLogin", true);
  }

  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    String? savedEmail = prefs.getString("email");
    String? savedPassword = prefs.getString("password");

    if (savedEmail == null || savedPassword == null) {
      return false;
    }

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool("isLogin", true);
      return true;
    }

    return false;
  }

  static Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("email");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", false);
  }

}