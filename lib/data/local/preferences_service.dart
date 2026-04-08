import 'dart:convert';

import 'package:adehun_mvp/domain/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  const PreferencesService(SharedPreferences prefs) : _prefs = prefs;

  // Keys
  static const _themeModeKey = 'theme_mode';
  static const _isLoggedInKey = 'is_logged_in';
  static const _isFirstLaunchKey = 'is_first_launch';
  static const _userKey = 'user';

  // Theme Mode
  String? get themeMode => _prefs.getString(_themeModeKey);
  Future<bool> setThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  // Logged In
  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;
  Future<bool> setLoggedIn(bool value) => _prefs.setBool(_isLoggedInKey, value);

  // First Launch
  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;
  Future<bool> setFirstLaunch(bool value) =>
      _prefs.setBool(_isFirstLaunchKey, value);

  // User data
  UserData? get user {
    final cache = _prefs.getString(_userKey);
    if (cache == null) return null;
    final json = jsonDecode(cache);
    return UserData.fromJson(json);
  }

  Future<bool> setUser(UserData? value) =>
      _prefs.setString(_userKey, jsonEncode(value?.toJson()));
}
