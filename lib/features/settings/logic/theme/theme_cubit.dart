import 'package:bloc/bloc.dart';
import 'package:finance_track/core/utils/caching/shared_pref.dart';
import 'package:finance_track/features/settings/logic/theme/theme_state.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeModeStr = await SharedPref().getThemeMode();
    final themeMode = _stringToThemeMode(themeModeStr);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await SharedPref().saveThemeMode(_themeModeToString(themeMode));
    emit(state.copyWith(themeMode: themeMode));
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String? modeStr) {
    switch (modeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
