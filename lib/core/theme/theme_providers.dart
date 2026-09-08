import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui_mode.dart';

const _uiModePrefsKey = 'ui_mode';
const _themeModePrefsKey = 'theme_mode';

class UiModeNotifier extends Notifier<UiMode> {
  @override
  UiMode build() {
    _load();
    return UiMode.modern;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_uiModePrefsKey);
    if (stored != null) {
      state = UiMode.values.byName(stored);
    }
  }

  Future<void> toggle() async {
    state = state == UiMode.classic ? UiMode.modern : UiMode.classic;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uiModePrefsKey, state.name);
  }
}

final uiModeProvider = NotifierProvider<UiModeNotifier, UiMode>(
  UiModeNotifier.new,
);

class AppThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeModePrefsKey);
    if (stored != null) {
      state = ThemeMode.values.byName(stored);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModePrefsKey, mode.name);
  }
}

final appThemeModeProvider = NotifierProvider<AppThemeModeNotifier, ThemeMode>(
  AppThemeModeNotifier.new,
);
