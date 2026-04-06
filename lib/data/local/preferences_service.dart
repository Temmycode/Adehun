import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  const PreferencesService(SharedPreferences prefs) : _prefs = prefs;

  // Keys
  static const _themeModeKey = 'theme_mode';
  static const _isLoggedInKey = 'is_logged_in';
  static const _isFirstLaunchKey = 'is_first_launch';

  // Theme Mode
  String? get themeMode => _prefs.getString(_themeModeKey);
  Future<bool> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  // Logged In
  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;
  Future<bool> setLoggedIn(bool value) =>
      _prefs.setBool(_isLoggedInKey, value);

  // First Launch
  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;
  Future<bool> setFirstLaunch(bool value) =>
      _prefs.setBool(_isFirstLaunchKey, value);
}
