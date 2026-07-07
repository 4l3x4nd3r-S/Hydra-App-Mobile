import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme => _build(Brightness.dark, AppColors.dark);
  static ThemeData get lightTheme => _build(Brightness.light, AppColors.light);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.background,
      primaryColor: c.primary,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: c.primary,
              surface: c.surface,
              onSurface: c.onSurface,
              onSurfaceVariant: c.onSurfaceVariant,
              outline: c.border,
            )
          : ColorScheme.light(
              primary: c.primary,
              surface: c.surface,
              onSurface: c.onSurface,
              onSurfaceVariant: c.onSurfaceVariant,
              outline: c.border,
            ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: c.onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: c.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: isDark ? 4 : 1,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
      ),
      dividerTheme: DividerThemeData(color: c.border),
      extensions: [c],
    );
  }
}
