import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  // Menyimpan data status Dark Mode
  static Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  // Mendapatkan data status Dark Mode
  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false; // Default ke false jika belum ada data
  }

  // Menyimpan nama pengguna (username)
  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  // Mendapatkan nama pengguna (username)
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
