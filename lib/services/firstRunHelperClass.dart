import 'package:shared_preferences/shared_preferences.dart';

class FirstRunHelper {
  static const String isFirstRunKey = 'isFirstRun';

  static Future<bool> isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool(isFirstRunKey) ?? true;
    return isFirstRun;
  }

  static Future<void> setFirstRunCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstRunKey, false);
  }
}
