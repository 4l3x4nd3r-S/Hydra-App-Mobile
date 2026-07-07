import 'package:flutter/material.dart';
import '../services/theme_storage_service.dart';

class ThemeRepository {
  final ThemeStorageService _themeStorage;

  ThemeRepository({required ThemeStorageService themeStorage})
      : _themeStorage = themeStorage;

  Future<ThemeMode> loadThemeMode() async {
    final saved = await _themeStorage.getThemeMode();
    return saved == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _themeStorage.saveThemeMode(
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }
}
