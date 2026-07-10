import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.border,
    required this.primary,
    required this.onSurface,
    required this.onSurfaceVariant,
  });

  final Color background;
  final Color surface;
  final Color border;
  final Color primary;
  final Color onSurface;
  final Color onSurfaceVariant;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? border,
    Color? primary,
    Color? onSurface,
    Color? onSurfaceVariant,
  }) =>
      AppColors(
        background: background ?? this.background,
        surface: surface ?? this.surface,
        border: border ?? this.border,
        primary: primary ?? this.primary,
        onSurface: onSurface ?? this.onSurface,
        onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
    );
  }

  static const AppColors dark = AppColors(
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF1C1C1C),
    border: Color(0xFF475569),
    primary: Color(0xFF0A2472),
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFFB0B0B0),
  );

  static const AppColors light = AppColors(
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFF94A3B8),
    primary: Color(0xFF0A2472),
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF64748B),
  );
}
