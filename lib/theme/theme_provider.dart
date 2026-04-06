import 'package:adehun_mvp/data/local/preferences_service.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final PreferencesService _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider(PreferencesService prefs) : _prefs = prefs {
    _loadPreference();
  }

  void _loadPreference() {
    final stored = _prefs.themeMode;
    if (stored != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (m) => m.name == stored,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setThemeMode(mode.name);
  }
}
