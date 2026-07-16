import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydra/ui/core/theme/app_colors.dart';
import 'package:hydra/ui/core/theme/app_theme.dart';

void main() {
  test('el calendario oscuro conserva fondo y texto con contraste', () {
    final theme = AppTheme.darkTheme;
    final datePicker = theme.datePickerTheme;

    expect(theme.colorScheme.brightness, Brightness.dark);
    expect(datePicker.backgroundColor, AppColors.dark.surface);
    expect(datePicker.headerBackgroundColor, AppColors.dark.surface);
    expect(datePicker.headerForegroundColor, AppColors.dark.onSurface);
    expect(
      datePicker.dayForegroundColor?.resolve(<WidgetState>{}),
      AppColors.dark.onSurface,
    );
    expect(
      datePicker.dayForegroundColor?.resolve({WidgetState.selected}),
      AppColors.dark.onPrimary,
    );
  });

  test('el selector de hora oscuro usa superficies oscuras', () {
    final timePicker = AppTheme.darkTheme.timePickerTheme;

    expect(timePicker.backgroundColor, AppColors.dark.surface);
    expect(timePicker.dialBackgroundColor, AppColors.dark.background);
    expect(timePicker.hourMinuteTextColor, AppColors.dark.onSurface);
  });
}
