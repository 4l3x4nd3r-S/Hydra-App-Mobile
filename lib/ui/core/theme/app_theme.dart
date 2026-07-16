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
              onPrimary: const Color(0xFF0F172A),
              surface: c.surface,
              onSurface: c.onSurface,
              onSurfaceVariant: c.onSurfaceVariant,
              outline: c.border,
            )
          : ColorScheme.light(
              primary: c.primary,
              onPrimary: Colors.white,
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
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.surface,
        headerForegroundColor: c.onSurface,
        dividerColor: c.border,
        weekdayStyle: TextStyle(
          color: c.onSurfaceVariant,
          fontFamily: 'Inter',
        ),
        dayStyle: TextStyle(color: c.onSurface, fontFamily: 'Inter'),
        yearStyle: TextStyle(color: c.onSurface, fontFamily: 'Inter'),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.onPrimary;
          if (states.contains(WidgetState.disabled)) {
            return c.onSurfaceVariant.withValues(alpha: 0.4);
          }
          return c.onSurface;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? c.primary : null;
        }),
        todayForegroundColor: WidgetStateProperty.all(c.primary),
        todayBorder: BorderSide(color: c.primary),
        yearForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return c.onPrimary;
          return c.onSurface;
        }),
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? c.primary : null;
        }),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(c.primary),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(c.primary),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: c.surface,
        hourMinuteColor: c.background,
        hourMinuteTextColor: c.onSurface,
        dialBackgroundColor: c.background,
        dialHandColor: c.primary,
        dialTextColor: c.onSurface,
        entryModeIconColor: c.primary,
        helpTextStyle: TextStyle(
          color: c.onSurfaceVariant,
          fontFamily: 'Inter',
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(c.primary),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(c.primary),
        ),
      ),
      extensions: [c],
    );
  }
}
