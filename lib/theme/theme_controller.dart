import 'package:adehun_mvp/data/local/preferences_service.dart';
import 'package:adehun_mvp/resources/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_controller.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  late PreferencesService _prefs;

  @override
  ThemeMode build() {
    final prefs = ref.read(preferencesServiceProvider);
    _prefs = prefs;
    final stored = prefs.themeMode;
    return stored != null
        ? ThemeMode.values.firstWhere(
            (m) => m.name == stored,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setThemeMode(mode.name);
  }
}
