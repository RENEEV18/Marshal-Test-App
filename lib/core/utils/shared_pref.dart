import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static SharedPreferences? _prefs;

  // Initialize once during app startup
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter for SharedPreferences
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("PrefsService not initialized. Call PrefsService.init() first.");
    }
    return _prefs!;
  }

  // Clear all prefs
  static Future<void> clearAll() async {
    await prefs.clear();
  }
}
