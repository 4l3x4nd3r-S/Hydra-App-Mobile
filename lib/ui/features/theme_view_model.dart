import 'package:flutter/material.dart';
import '../../data/repositories/theme_repository.dart';

class ThemeViewModel extends ChangeNotifier {
  final ThemeRepository _themeRepository;

  ThemeMode _mode = ThemeMode.dark;
  ThemeMode get mode => _mode;
  bool get isLight => _mode == ThemeMode.light;

  ThemeViewModel({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository;

  Future<void> load() async {
    _mode = await _themeRepository.loadThemeMode();
    notifyListeners();
  }

  Future<void> toggle() async {
    _mode =
        _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _themeRepository.saveThemeMode(_mode);
    notifyListeners();
  }
}
